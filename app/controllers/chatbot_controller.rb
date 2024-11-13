# /home/mauriciosg/chatbotecM/app/controllers/chatbot_controller.rb
class ChatbotController < ApplicationController
  protect_from_forgery with: :null_session  # Permite solicitudes AJAX sin verificar CSRF

  def ask
    question = params[:question]
    answer = generate_answer(question)  # Generar la respuesta basada en la pregunta
    render json: { answer: answer }  # Devolver la respuesta como JSON
  end

  private

  def generate_answer(question)
    # Convertir la pregunta a minúsculas y limpiar caracteres especiales
    cleaned_question = clean_text(question)

    # Buscar productos que coincidan con las palabras clave filtradas
    products = Spree::Product.all
    matched_product = find_best_match(cleaned_question, products)

    if matched_product
      "Sí, tenemos el producto '#{matched_product.name}' disponible por $#{matched_product.price}. ¡Haz tu pedido!"
    else
      "Lo siento, no pude encontrar un producto relacionado con '#{question}'."
    end
  end

  def clean_text(text)
    # Palabras irrelevantes (stopwords)
    stopwords = %w[tienes disponible el la los las un una de del por para a en con y o que es]
    
    # Normalizar texto: eliminar puntuación y convertir a minúsculas
    normalized_text = text.downcase.gsub(/[^a-z\s]/, '')

    # Eliminar palabras irrelevantes
    keywords = normalized_text.split.reject { |word| stopwords.include?(word) }.join(' ')

    keywords
  end

  def find_best_match(cleaned_question, products)
    # Realizar una búsqueda básica de coincidencia de palabras clave
    products.find do |product|
      cleaned_product_name = clean_text(product.name)
      # Comparar palabras clave de la pregunta con el nombre del producto
      cleaned_question.include?(cleaned_product_name) || cleaned_product_name.include?(cleaned_question)
    end
  end
end
