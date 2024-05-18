shader_type canvas_item;

uniform float thickness = 1.f;
uniform vec4 color: source_color = vec4(1,1,1,1);

void fragment() {
	vec4 c = texture(TEXTURE, UV);
	
	vec2 sample_size = TEXTURE_PIXEL_SIZE * thickness;
	vec2 sample1 = UV + vec2(sample_size.x, 0);
	vec2 sample2 = UV + vec2(-sample_size.x, 0);
	vec2 sample3 = UV + vec2(0, sample_size.y);
	vec2 sample4 = UV + vec2(0, -sample_size.y);
	vec2 sample5 = UV + vec2(sample_size.x, sample_size.y);
	vec2 sample6 = UV + vec2(sample_size.x, -sample_size.y);
	vec2 sample7 = UV + vec2(-sample_size.x, -sample_size.y);
	vec2 sample8 = UV + vec2(-sample_size.x, sample_size.y);
	vec2 samples[8] = {sample1,sample2,sample3,sample4,sample5,sample6,sample7,sample8};
	float res = 0.f;
	for(int i = 0; i < 8; i++){
		vec4 p = texture(TEXTURE, samples[i]);
		res += p.a;
	}
	res /= 8.f;
	res = sin(PI * res);
	vec3 final_color = c.xyz + (1.f - c.a) * color.xyz;
	COLOR = vec4(final_color, max(res, c.a));
}
