module AiProviders
  class OpenaiProvider
    def self.generate_answer(prompt:, model: "gpt-4", system_prompt: Answer.system_prompt, max_tokens: nil)
      client = OpenAI::Client.new

      # Prepend instruction to a response similar to what you might see in Ask Extension
      friendly_prompt = "Please explain this in a conversational, in a single paragraph, without using numbered lists or bullet points:\n\n#{prompt}"

      response = client.chat(
        parameters: {
          model: model,
          messages: [
            { role: "system", content: system_prompt },
            { role: "user", content: friendly_prompt }
          ],
          temperature: 0.7,
          max_tokens: max_tokens
        }.compact
      )

      raw_text = response.dig("choices", 0, "message", "content")&.strip
      clean_text = trim_to_last_complete_sentence(raw_text)
      clean_text
    end

    # Gracefully cuts off incomplete sentences at the end
    def self.trim_to_last_complete_sentence(text)
      return "" if text.blank?

      # Trim to last complete sentence
      sentences = text.scan(/[^.!?]+[.!?]/)
      trimmed = sentences.join.strip

      # Remove orphaned list item if present at end
      trimmed.gsub!(/(?:\n|\r)?\s*(\d+\.\s*|\-\s*|\*\s*)$/, '')

      trimmed.strip
    end
  end
end



# app/services/ai_providers/
# ├── openai_provider.rb
# ├── anthropic_provider.rb  # ← just add this
# └── gemini_provider.rb     # ← and this
