let recognition;

function startRecognition() {
  if (!('webkitSpeechRecognition' in window)) {
    alert('Lo siento, tu navegador no soporta el reconocimiento de voz.');
    return;
  }

  recognition = new webkitSpeechRecognition();
  recognition.continuous = false;
  recognition.interimResults = false;
  recognition.lang = 'es-ES';

  recognition.onresult = function(event) {
    const transcript = event.results[0][0].transcript;
    document.getElementById("chatbot_input").value = transcript;
    askChatbot();
  };

  recognition.start();
}

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
    speakAnswer(data.answer);
  })
  .catch(error => console.error('Error:', error));
}

function speakAnswer(answer) {
  responsiveVoice.speak(answer, "Spanish Latin American Female");
}
