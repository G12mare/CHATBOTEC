# app/services/gemini_client.rb
require 'httparty'

class GeminiClient
  include HTTParty
  base_uri 'https://api.gemini.com'  # Aquí debes colocar la URL correcta de la API

  def ask(question)
    response = self.class.get('/ask', query: { question: question })

    # Verifica si la respuesta es exitosa
    if response.success?
      return response.parsed_response["answer"]
    else
      return "Error: #{response.message}"
    end
  rescue StandardError => e
    # Captura cualquier error
    return "Error: #{e.message}"
  end
end

