class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @questions = Question.order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def require_admin
    redirect_to root_path, alert: 'Not authorized' unless current_user&.admin?
  end
end