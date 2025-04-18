class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :source

  def self.promote_from_question!(question:, source:, ai_source: nil)
    return if question.reviewed_and_edited_answer.blank?
    return if question.answers.exists?(source_id: source.id)

    # Human-reviewed answer
    question.answers.create!(
      source: source,
      text: question.reviewed_and_edited_answer,
      author: "System (auto-promoted)",
      approved: true,
      user_submitted: false,
      display_order: 1
    )

    return unless ai_source && !question.answers.exists?(source_id: ai_source.id)

    # === Replace this with actual OpenAI call when ready ===
    ai_answer_text = <<~TEXT
      This is a placeholder AI-generated response for development purposes. 
      In production, this would be replaced by a real response from GPT-4 or another AI model.
    TEXT

    # Uncomment when ready to use real API
    # response = OpenAI::Client.new.chat(
    #   parameters: {
    #     model: "gpt-4",
    #     messages: [
    #       { role: "system", content: "You are a helpful Cooperative Extension agent." },
    #       { role: "user", content: question.question }
    #     ],
    #     temperature: 0.7
    #   }
    # )
    # ai_answer_text = response.dig("choices", 0, "message", "content")

    question.answers.create!(
      source: ai_source,
      text: ai_answer_text.strip,
      author: "System (AI-generated)",
      approved: true,
      user_submitted: false,
      display_order: 2
    )
  end
  
  def source_is_human?
    source&.is_human
  end

end
