# run with rails "import:questions[500]" or drop in whatever number of questions you want to import
def scrub_data(html, author_name)
  cleaned = html.dup

  # Remove <div> blocks with email headers
  patterns = [
    /<div[^>]*>.*?<b>From:.*?<\/div>/im,
    /<div[^>]*>.*?<b>Sent:.*?<\/div>/im,
    /<div[^>]*>.*?<b>To:.*?<\/div>/im,
    /<div[^>]*>.*?<b>Subject:.*?<\/div>/im
  ]
  patterns.each { |pattern| cleaned.gsub!(pattern, "") }

  # Remove mailto: links entirely (strip the <a href="mailto:...">...</a> block)
  cleaned.gsub!(/<a\s+href=["']mailto:[^>]+>(.*?)<\/a>/i, '[email removed]')

  # Strip bare email addresses
  cleaned.gsub!(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i, '[email removed]')

  # Strip US-style phone numbers
  cleaned.gsub!(/(\+1\s*)?(\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4})/, '[phone removed]')

  # Strip closing signature that includes the author’s name
  if author_name.present?
    cleaned.gsub!(/(<br\s*\/?>\s*)?(Thanks|Thank you|Kind regards|Sincerely)?\s*(<br\s*\/?>\s*)?#{Regexp.escape(author_name)}/i, "")
  end

  cleaned.strip
end


namespace :import do
  desc "Import AskAI question data from JSON in root dir. Usage: rails 'import:questions[10]'"
  task :questions, [:limit] => :environment do |_, args|
    file_path = Rails.root.join("..", "shared", "questions.json")

    unless File.exist?(file_path)
      puts "❌ File not found at: #{file_path}"
      next
    end

    puts "🧨 Clearing existing questions..."
    Question.delete_all

    data = JSON.parse(File.read(file_path))
    limit = args[:limit]&.to_i || data.size
    puts "📥 Importing up to #{limit} questions..."

    data.first(limit).each_with_index do |entry, index|
      full_thread = ""

      if entry["answer"]
        answers_array = if entry["answer"].is_a?(Hash)
                          entry["answer"].values
                        elsif entry["answer"].is_a?(Array)
                          entry["answer"]
                        else
                          []
                        end

        answers_array.each_with_index do |answer_data, i|
          # Skip if no response text
          next unless answer_data.is_a?(Hash) && answer_data["response"].present?

          author = answer_data["author"] || "Unknown"
          cleaned_response = scrub_data(answer_data["response"], author)
          full_thread += "<strong>Answer ##{i + 1}:</strong><br>\n#{cleaned_response}<br><br>"
        end
      end
      
      question = Question.find_or_initialize_by(faq_id: entry["faq-id"])
      question.title = entry["title"]
      question.text = entry["question"]
      question.state = entry["state"]
      question.county = entry["county"]
      question.full_conversation_thread = full_thread.strip
      question.image_present = entry.key?("attachments") && entry["attachments"].any?
      question.created_at = entry["created"]
      question.updated_at = entry["updated"]
      question.save!

      puts "✅ [#{index + 1}] #{question.title.truncate(60)}"
    end

    puts "🎉 Import complete! #{[limit, data.size].min} questions loaded."
  end
end
