# lib/gemini_client.rb
require 'google/cloud/gemini'

class GeminiClient
  def self.ask_product_question(question)
    gemini = Google::Cloud::Gemini.new
    
    # Llamada a la API de Gemini con la pregunta
    response = gemini.query(question: question)
    
    # Devuelve solo la respuesta en texto
    response.answer
  end
end

