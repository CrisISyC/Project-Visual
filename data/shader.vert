precision highp float;

attribute vec3 aPosition;
uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;
uniform float uTime;
uniform float uAmplitude;

// Función para generar ruido (suaviza la deformación)
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
    vec3 pos = aPosition;

    // 🟢 Aplicar deformación suave solo cuando haya sonido
    if (uAmplitude > 0.0) {
        float strength = 0.1 + uAmplitude * 1.5; // Intensidad de la deformación
        float freq = 5.0 + uAmplitude * 20.0; // Suaviza las arrugas

        // Usamos `noise()` en lugar de `sin()` para transiciones más suaves
        float displacement = noise(pos.xy * freq + vec2(uTime * 0.5, uTime * 0.3)) * strength;

        pos += normalize(pos) * displacement;
    }

    gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(pos, 1.0);
}
