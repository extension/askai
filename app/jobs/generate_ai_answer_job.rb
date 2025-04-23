class GenerateAiAnswerJob < ApplicationJob
  queue_as :default

  def perform(question_id, source_id, model_provider = "openai", desired_length = nil)
    question = Question.find_by(id: question_id)
    return unless question

    provider = case model_provider
               when "openai"
                 AiProviders::OpenaiProvider
               # when "anthropic"
               #   AiProviders::AnthropicProvider
               else
                 raise "Unknown AI provider: #{model_provider}"
               end

    # ai_text = provider.generate_answer(prompt: question.text)
    ai_text = provider.generate_answer(prompt: question.text, max_tokens: desired_length)

    if ai_text.present?
      question.answers.create!(
        source_id: source_id,
        text: ai_text,
        author: "System (AI-generated)",
        approved: true,
        user_submitted: false,
        display_order: 2
      )
    end
  rescue => e
    Rails.logger.error("[AI Job] Failed to generate AI answer: #{e.message}")
  end
end


# +----------------------+
# | Rake Task / UI Form |
# |  (creates Question)  |
# +----------+-----------+
#            |
#            | triggers
#            v
# +-----------------------------+
# | Answer.promote_from_question! |
# |  - Promotes human answer     |
# |  - Queues AI job             |
# +--------------+--------------+
#                |
#                | perform_later
#                v
#      +------------------------+
#      | GenerateAiAnswerJob   |
#      |  (Background Job)      |
#      +-----------+------------+
#                  |
#                  | selects provider
#                  v
#      +-----------------------------+
#      | AiProviders::<Model>Provider|
#      |  e.g. OpenaiProvider        |
#      +-------------+---------------+
#                    |
#                    | calls API (e.g. OpenAI)
#                    v
#         +-----------------------+
#         | External LLM API      |
#         | (e.g., GPT-4)         |
#         +----------+------------+
#                    |
#                    | returns text
#                    v
#          +--------------------------+
#          | Answer.create!           |
#          | - Saves AI-generated     |
#          |   answer to DB           |
#          +--------------------------+
