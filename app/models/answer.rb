class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :source

  def self.promote_from_question!(question:, source:, ai_source: nil)
    return if question.reviewed_and_edited_answer.blank?
    return if question.answers.exists?(source_id: source.id)

    # Promote human-reviewed answer
    question.answers.create!(
      source: source,
      text: question.reviewed_and_edited_answer,
      author: "System (auto-promoted)",
      approved: true,
      user_submitted: false,
      display_order: 1
    )

    # Queue async job for AI answer
    if ai_source && !question.answers.exists?(source_id: ai_source.id)
      GenerateAiAnswerJob.perform_later(question.id, ai_source.id)
    end
  end

  def self.system_prompt
    "You are a helpful Cooperative Extension agent who provides science-based, practical, and regionally-relevant advice to the public."
  end

  def source_is_human?
    source&.is_human
  end
end