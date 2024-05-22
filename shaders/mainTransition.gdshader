shader_type canvas_item;

uniform float degInRad = 0.0;
uniform float x = 0.0;
uniform bool reverse = false;

vec2 squarify(float ratioYOverX, vec2 ori){
	return vec2(ori.x, (ori.y - 0.5) * ratioYOverX + 0.5);
}

void fragment() {
	vec2 dir = vec2(cos(degInRad), sin(degInRad));
	vec2 normal = vec2(-sin(degInRad), cos(degInRad));
	float dist = dir.x * UV.x + dir.y * UV.y - 0.5 * (dir.x + dir.y);
	dist = abs(dist);
	if (!reverse) {
		COLOR = (1.0 - step(x, dist)) * vec4(0, 0, 0, 1) + step(x, dist) * vec4(0, 0, 0, 0);	
	} else {
		COLOR = (1.0 - step(x, dist)) * vec4(0, 0, 0, 0) + step(x, dist) * vec4(0, 0, 0, 1);
	}
}