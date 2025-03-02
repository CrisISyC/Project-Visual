let myShader;
let sound, amp;

function preload() {
  myShader = loadShader('data/shader.vert', 'data/shader.frag');
  sound = loadSound('data/Audio.mp3'); // 🎵 Cambia esto por tu archivo de audio
}

function setup() {
  createCanvas(400, 400, WEBGL);
  noStroke();

  // 🎧 Habilitar análisis de sonido
  amp = new p5.Amplitude();

  // Botón para reproducir audio
  let button = createButton("Play / Pause");
  button.mousePressed(togglePlay);
}

function draw() {
  background(255);
  orbitControl()
  let level = amp.getLevel(); // 🔊 Obtener volumen del audio
  let amplitude = map(level, 0, 1, 0, 0.5); // Ajustar escala

  // 🟢 Si el sonido es muy bajo, desactivar arrugas
  if (amplitude < 0.01) {
    amplitude = 0.0; // Mantiene la esfera normal
  }

  myShader.setUniform("uTime", millis() * 0.001);
  myShader.setUniform("uAmplitude", amplitude); // 🔥 Pasar amplitud al shader

  shader(myShader);
  sphere(80);
}

function togglePlay() {
  if (sound.isPlaying()) {
    sound.pause();
  } else {
    sound.loop();
  }
}
