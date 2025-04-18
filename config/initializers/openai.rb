# Configure the OpenAI API client
OpenAI.configure do |config|
  config.access_token = ENV.fetch("OPENAI_API_KEY") # Assumes you've set the environment variable
end


# Initialize the OpenAI client
client = OpenAI::Client.new