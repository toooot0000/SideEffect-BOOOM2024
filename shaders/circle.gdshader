shader_type canvas_item;
render_mode unshaded;

#include "include/noise.gdshaderinc"
#include "include/polarProjection.gdshaderinc"

uniform float radiusInPixel = 200.f;
uniform float thicknessInPixel = 3.f;
uniform vec2 normaledCenter = vec2(.5f);
uniform float ripplePositions[5];
uniform float rippleTimes[5];
uniform float reRipplePositions[5];
uniform float reRippleTimes[5];

float stepRange(float front_edge, float back_edge, float a){
	a = (a - front_edge)/(back_edge - front_edge);
	return step(0.f, a) * step(0.f, 1.f - a);
}

float mapEdge(float i, float thick){
	float halfThick = thick * .5f;
	float normalizedI = (i + halfThick)/thick;
	return stepRange(0.f, 1.f, normalizedI);
}

float drawCircle(vec2 pixelPosition, float radius, float thick){
	return mapEdge(distance(vec2(0.f), pixelPosition) - radius, thick);
}

float ripple(float x, float rippleTime) {
	float i = x;
	float a = 2.46;
	float g = rippleTime;
	float f1 = cos(a * (i - g) * PI) * exp(-5.6 * i - 2.f * g);
	float f2 = cos(a * (- i - g) * PI) * exp(-5.6 * -i - 2.f * g);
	return x > 0.f ? f1 : f2;
}

float positionToOffset(float position, vec2 point){
	float rippleAngRad = position * 2.f * PI - PI;
	vec2 polar = toPolar(point);
	float theta = getTheta(polar);
	float offset = abs(theta - position);
	if (offset > PI) {
		offset = 2.f * PI - offset;
	}
	offset = offset / (2.f * PI);
	offset *= 10.f;
	return offset;
}

void fragment() {
	
	vec2 textSize = vec2(1.f) / SCREEN_PIXEL_SIZE;
	vec2 ratio = vec2(1, SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y);
	vec2 point = (SCREEN_UV - normaledCenter) * ratio * vec2(textSize.x);
	
	float rippleLength = 0.f;
	float reRippleLength = 0.f;
	for(int i = 0; i < 5; i++){
		float ripplePosition = ripplePositions[i];
		float time = rippleTimes[i];
		float offset = positionToOffset(ripplePosition, point);
		rippleLength += ripple(offset, time) * 20.0f;
	}
	
	for(int i = 0; i < 5; i++){
		float ripplePosition = reRipplePositions[i];
		float time = reRippleTimes[i];
		float offset = positionToOffset(ripplePosition, point);
		reRippleLength += ripple(offset, time) * 20.0f;
	}
	
	float circle = drawCircle(point, radiusInPixel + rippleLength - reRippleLength, thicknessInPixel);
	
	COLOR = vec4(1) * (1.f - circle)  + vec4(0, 0, 0, 1) * circle;
}