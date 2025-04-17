# app/controllers/answers_controller.rb
class AnswersController < ApplicationController
  def public_index
    # Group approved answers by question and filter to only those that have 1 human + 1 AI answer
    grouped = Answer
      .includes(:question, :source)
      .where(approved: true)
      .group_by(&:question)

    @question_answer_pairs = grouped.select do |_question, answers|
      answers.any?(&:source_is_human?) && answers.any? { |a| !a.source_is_human? }
    end
  end
end