float rand_float(float n) {
	return fract(sin(n) * 43758.5453123);
}

float rand_vec2(vec2 n) {
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise_float(float p) {
	float fl = floor(p);
  	float fc = fract(p);
	return mix(rand_float(fl), rand_float(fl + 1.0), fc);
}
	
float noise_vec2(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand_vec2(b), rand_vec2(b + d.yx), f.x), mix(rand_vec2(b + d.xy), rand_vec2(b + d.yy), f.x), f.y);
}