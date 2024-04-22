
vec2 toPolar(vec2 cartesian){
	float theta = atan(cartesian.y, cartesian.x);
	float r = length(cartesian);
	return vec2(r, theta);
}

vec2 toCart(vec2 polar){
	return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

float getR(vec2 polar) { return polar.x; }
float getTheta(vec2 polar) { return polar.y; }