class QuestionsController < ApplicationController
  def index
    @questions = Question.order(created_at: :desc).limit(50)
  end
end