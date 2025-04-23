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
      human_answer = question.answers.where.not(author: 'System (AI-generated)').last
      #getting length of human answer and passing it to AI so the lengths are similar
      desired_length = (human_answer.text.length / 7.0).round
      puts "desired_length is:" + desired_length.to_s
      GenerateAiAnswerJob.perform_later(question.id, ai_source.id, 'openai', desired_length)
    end
  end

  def self.system_prompt
    "You are a helpful Cooperative Extension agent who provides science-based, practical, and regionally-relevant advice to the public."
  end

  def source_is_human?
    source&.is_human
  end
end