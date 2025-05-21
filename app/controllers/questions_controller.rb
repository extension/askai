class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  skip_before_action :authenticate_user!, only: [:index]
  skip_before_action :require_admin, only: [:index]

  def index
    @questions = Question.order(created_at: :desc)
    if params[:status].present?
      @questions = @questions.where(status: params[:status])
    end

    if params[:no_images] == 'true'
      @questions = @questions.without_images
    end

    @questions = @questions.page(params[:page]).per(10)
  end

  def edit
    @question = Question.find(params[:id])

    # Pre-fill edited answer if it's blank
    if @question.reviewed_and_edited_answer.blank?
      @question.reviewed_and_edited_answer = @question.full_conversation_thread
    end
  end

  def update
    @question = Question.find(params[:id])

    if @question.update(question_params)
      # Sync the answer if it exists
      if @question.status == "approved" && @question.answers.any?
        @question.answers.each do |answer|
          answer.update!(
            text: @question.reviewed_and_edited_answer
          )
        end
      end

      redirect_to questions_path, notice: "Question updated."
    else
      render :edit
    end
  end

  def approve
    @question = Question.find(params[:id])
    @question.update!(status: 'approved', approved: true)

    human_source = Source.find_by(name: "Ask Extension Expert")
    #todo: we should randomize the finder below to get a radom ai source one we have more than one
    ai_source = Source.find_by(is_human: false)

    Answer.promote_from_question!(
      question: @question,
      source: human_source,
      ai_source: ai_source
    )

    redirect_to questions_path, notice: "Question approved and answer promoted!"
  end

  def reject
    @question = Question.find(params[:id])
    @question.update!(status: 'rejected', approved: false)
    redirect_to questions_path, notice: "Question rejected."
  end


  private

  def question_params
    params.require(:question).permit(:title, :reviewed_and_edited_answer)
  end

  def require_admin
    redirect_to root_path, alert: 'Not authorized' unless current_user&.admin?
  end
end