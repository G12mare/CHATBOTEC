function askChatbot() {
    const question = document.getElementById("chatbot_input").value;

    // Enviar la pregunta al servidor usando fetch
    fetch('/chatbot/ask', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')  // Asegura que el token CSRF esté presente
        },
        body: JSON.stringify({ question: question })  // Convertimos la pregunta a JSON
    })
    .then(response => response.json())  // Parsear la respuesta JSON
    .then(data => {
        // Mostrar la respuesta del chatbot en el div con id 'chatbot_response'
        document.getElementById("chatbot_response").innerText = data.answer;
    })
    .catch(error => {
        console.error('Error:', error);
        document.getElementById("chatbot_response").innerText = "Hubo un error al procesar tu pregunta.";
    });
}

  