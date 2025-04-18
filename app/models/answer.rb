class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :source

  def self.promote_from_question!(question:, source:, ai_source: nil)
    return if question.reviewed_and_edited_answer.blank?
    return if question.answers.exists?(source_id: source.id)

    # Create human-reviewed answer
    question.answers.create!(
      source: source,
      text: question.reviewed_and_edited_answer,
      author: "System (auto-promoted)",
      approved: true,
      user_submitted: false,
      display_order: 1
    )

    return unless ai_source && !question.answers.exists?(source_id: ai_source.id)

    # === GPT-4 AI answer generation ===
    begin
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: "gpt-4",
          messages: [
            { role: "system", content: system_prompt },
            { role: "user", content: question[:text] }
          ],
          temperature: 0.7
        }
      )

      ai_answer_text = response.dig("choices", 0, "message", "content")&.strip

      if ai_answer_text.present?
        question.answers.create!(
          source: ai_source,
          text: ai_answer_text,
          author: "System (AI-generated)",
          approved: true,
          user_submitted: false,
          display_order: 2
        )
      end
    rescue => e
      Rails.logger.error("[Answer] AI generation failed for Question #{question.id}: #{e.message}")
    end
  end

  def self.system_prompt
    "You are a helpful Cooperative Extension agent who provides science-based, practical, and regionally-relevant advice to the public."
  end

  def source_is_human?
    source&.is_human
  end

end
