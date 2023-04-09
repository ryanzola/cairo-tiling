#define PI 3.1415926535897932384626433832795
#define TAU 6.283185307179586476925286766559

varying vec2 vUv;
uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

float Hash21(vec2 p) {
  vec2 k1 = vec2(
      23.14069263277926, // e^pi (Gelfond's constant)
      2.665144142690225 // 2^sqrt(2) (Gelfond-Schneider constant)
  );
  return fract(
      cos(dot(p, k1)) * 12345.6789
  );
}

vec3 Cairo(vec2 uv, float k) {
  vec2 id = floor(uv);
  float check = mod(id.x + id.y, 2.0);    // 0 or 1

  uv = fract(uv) - 0.5;

  vec2 p = abs(uv);

  // rotate the tile if check is 1
  if (check == 1.) p = p.yx;

  // debug with mouse position
  // float k = u_mouse.y;
  
  float a = (k * 0.5 + 0.5)*PI;
  vec2 n = vec2(sin(a), cos(a));

  float d = dot(p - 0.5, n);    // slanted line

  // which quadrant are we in?
  if (d * (check - 0.5) < 0.0) {
    id.x += sign(uv.x) * 0.5;
  } else {
    id.y += sign(uv.y) * 0.5;
  }

  d = min(d, p.x);              // straight line
  d = max(d, -p.y);             // straight line
  d = abs(d);

  // consider the neighboring line
  d = min(d, dot(p - 0.5, vec2(n.y, -n.x)));

  return vec3(id, d);
}
 
void main() {
  vec2 shiftedUv = vUv - vec2(0.5);
  float aspectRatio = u_resolution.x / u_resolution.y;
  shiftedUv.x *= aspectRatio;

  vec3 col = vec3(0.0);
  shiftedUv *= 3.1;

  vec3 c = Cairo(shiftedUv, u_mouse.y);

  col += c.z;

  // random value for every pentagon
  float r = Hash21(c.xy);
  col *= 1.0 * sin(r * TAU + u_time);
  col += smoothstep(fwidth(c.z), 0.0, c.z - 0.005);

  // debug grid lines
  // if (max(p.x, p.y) > 0.49) col.r  += 0.8;

  gl_FragColor = vec4(col, 1.0);
}