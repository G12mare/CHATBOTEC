# app/services/gemini_client.rb
class GeminiClient
  require 'net/http'
  require 'uri'
  require 'json'

  BASE_URL = 'https://api.gemini.com'

  def ask(question)
    uri = URI.parse("#{BASE_URL}/ask")
    response = Net::HTTP.post_form(uri, 'question' => question)
    JSON.parse(response.body)["answer"]
  rescue StandardError => e
    # Handle errors if needed
    "Error: #{e.message}"
  end
end

