class QuestionsController < ApplicationController
  def index
    @questions = Question.order(created_at: :desc).page(params[:page]).per(10)
  end
end