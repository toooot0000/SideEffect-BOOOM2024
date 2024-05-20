shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float x: hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;
	
	//COLOR = vec4(UV, 0, COLOR.a);
	COLOR = vec4(vec3(1) - COLOR.xyz, COLOR.a) * step(1.0 - x, UV.x)  + (1.0 - step(1.0 - x, UV.x)) * COLOR;
}