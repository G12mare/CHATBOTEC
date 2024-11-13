// app/javascript/packs/chatbot.js

// Función para iniciar el reconocimiento de voz
function startVoiceRecognition() {
  const recognition = new (window.SpeechRecognition || window.webkitSpeechRecognition)();
  recognition.lang = 'es-ES';  // Configura el idioma (ajústalo si es necesario)
  recognition.interimResults = false;

  recognition.onresult = function(event) {
      const question = event.results[0][0].transcript;
      document.getElementById("chatbot_input").value = question;
      askChatbot();  // Llama a la función para procesar la pregunta
  };

  recognition.onerror = function(event) {
      console.error('Error en el reconocimiento de voz:', event.error);
  };

  recognition.start();  // Inicia el reconocimiento de voz
}

// Función para enviar la pregunta al backend y mostrar la respuesta
function askChatbot() {
  const question = document.getElementById("chatbot_input").value;

  fetch('/chatbot/ask', {
      method: 'POST',
      headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ question: question })
  })
  .then(response => response.json())
  .then(data => {
      document.getElementById("chatbot_response").innerText = data.answer;
      speakResponse(data.answer);  // Llama a la función para leer la respuesta en voz alta
  })
  .catch(error => {
      console.error('Error:', error);
      document.getElementById("chatbot_response").innerText = "Hubo un error al procesar tu pregunta.";
  });
}

// Función para leer la respuesta en voz alta
function speakResponse(response) {
  if ('speechSynthesis' in window) {
      const utterance = new SpeechSynthesisUtterance(response);
      utterance.lang = 'es-ES';  // Configura el idioma (ajústalo si es necesario)
      window.speechSynthesis.speak(utterance);
  } else {
      console.warn("El navegador no soporta Speech Synthesis.");
  }
}

// Exponer la función globalmente si es necesario
window.startVoiceRecognition = startVoiceRecognition;
