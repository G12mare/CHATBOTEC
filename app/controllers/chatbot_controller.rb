class ChatbotController < ApplicationController
  protect_from_forgery with: :null_session  # Permite solicitudes AJAX sin verificar CSRF

  def ask
    question = params[:question]
    answer = generate_answer(question)  # Generar la respuesta basada en la pregunta
    render json: { answer: answer }  # Devolver la respuesta como JSON
  end

  private

  def generate_answer(question)
    # Convertir la pregunta a minúsculas para hacer la búsqueda insensible a mayúsculas/minúsculas
    question = question.downcase

    # Buscar productos que coincidan con la pregunta
    products = Spree::Product.where("LOWER(name) LIKE ?", "%#{question}%")

    if products.any?
      # Si se encuentra al menos un producto, devolver información sobre el primero
      product = products.first  # Obtener el primer producto que coincida
      "Sí, tenemos el producto '#{product.name}' disponible por $#{product.price}. ¡Haz tu pedido!"
    else
      # Si no se encuentra el producto
      "Lo siento, no pude encontrar un producto relacionado con '#{question}'."
    end
  end
end


