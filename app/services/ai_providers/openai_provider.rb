module AiProviders
  class OpenaiProvider
    def self.generate_answer(prompt:, model: "gpt-4", system_prompt: Answer.system_prompt, max_tokens: nil)
      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: model,
          messages: [
            { role: "system", content: system_prompt },
            { role: "user", content: prompt }
          ],
          temperature: 0.7,
          max_tokens: max_tokens
        }.compact # This ensures nil values are not sent
      )
      response.dig("choices", 0, "message", "content")&.strip
    end
  end
end

# app/services/ai_providers/
# ├── openai_provider.rb
# ├── anthropic_provider.rb  # ← just add this
# └── gemini_provider.rb     # ← and this
