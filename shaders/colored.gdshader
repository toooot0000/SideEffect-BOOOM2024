shader_type canvas_item;

uniform vec4 color;

void fragment() {
	vec4 oriColor = texture(TEXTURE, UV);
	COLOR =  vec4(mix(oriColor.xyz, color.xyz, color.a), oriColor.a);
}
