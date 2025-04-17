class QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  skip_before_action :authenticate_user!, only: [:public_index]
  skip_before_action :require_admin, only: [:public_index]

  def index
    @questions = Question.order(created_at: :desc)
    if params[:status].present?
      @questions = @questions.where(status: params[:status])
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
      redirect_to questions_path, notice: "Question updated."
    else
      render :edit
    end
  end

  def approve
    @question = Question.find(params[:id])
    @question.update!(status: 'approved', approved: true)

    # Promote reviewed human answer to the answers table
    source = Source.find_by(name: "Ask Extension Expert")
    @question.promote_reviewed_answer_to_answer!(source: source)
  # Dev-only: Mock AI answer
    generated_source = Source.find_by(name: "Mockup for Testing")

    # 👇 Replace this mock with actual OpenAI API when ready
    ai_answer_text = <<~TEXT
      This is a placeholder AI-generated response for development purposes. 
      In production, this would be replaced by a real response from GPT-4 or another AI model.
    TEXT

    # === Uncomment this when ready to call the real API ===
    # response = OpenAI::Client.new.chat(
    #   parameters: {
    #     model: "gpt-4",
    #     messages: [
    #       { role: "system", content: "You are a helpful Cooperative Extension agent." },
    #       { role: "user", content: @question.question }
    #     ],
    #     temperature: 0.7
    #   }
    # )
    # ai_answer_text = response.dig("choices", 0, "message", "content")

    @question.answers.create!(
      source: generated_source,
      text: ai_answer_text.strip,
      approved: true,
      user_submitted: false,
      display_order: 2
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