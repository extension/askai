class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @questions = Question.order(created_at: :desc).page(params[:page]).per(10)
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to questions_path, notice: "Question updated."
    else
      render :edit
    end
  end

  def approve
    @question = Question.find(params[:id])
    @question.update(status: "approved")
    redirect_to questions_path, notice: "Question approved."
  end

  def reject
    @question = Question.find(params[:id])
    @question.update(status: "rejected")
    redirect_to questions_path, notice: "Question rejected."
  end

  private

  def question_params
    params.require(:question).permit(:title, :full_conversation_thread)
  end

  def require_admin
    redirect_to root_path, alert: 'Not authorized' unless current_user&.admin?
  end
end