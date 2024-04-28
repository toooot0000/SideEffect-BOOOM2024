shader_type canvas_item;

// Camera FOV
uniform vec2 rotation_pivot = vec2(0.5);

uniform float fov : hint_range(1, 179) = 90;
uniform float y_rot : hint_range(-180, 180) = 0.0;
uniform float x_rot : hint_range(-180, 180) = 0.0;
// At 0, the image retains its size when unrotated.
// At 1, the image is resized so that it can do a full
// rotation without clipping inside its rect.
uniform float inset : hint_range(0, 1) = 0.0;
// Consider changing this to a uniform and change it from code
varying mat3 rotmat;
varying float tang;

// Creates rotation matrix
void vertex(){
	float sin_b = sin(y_rot / 180.0 * PI);
	float cos_b = cos(y_rot / 180.0 * PI);
	float sin_c = sin(x_rot / 180.0 * PI);
	float cos_c = cos(x_rot / 180.0 * PI);
	
	rotmat[0][0] = cos_b;
	rotmat[0][1] = sin_b * sin_c;
	rotmat[0][2] = sin_b * cos_c;
	
	rotmat[1][0] = 0.0;
	rotmat[1][1] = cos_c;
	rotmat[1][2] = -sin_c;
	
	rotmat[2][0] = -sin_b;
	rotmat[2][1] = cos_b * sin_c;
	rotmat[2][2] = cos_b * cos_c;
	tang = tan(fov / 360.0 * PI);
	VERTEX += (UV - 0.5) / TEXTURE_PIXEL_SIZE * tang * (1.0 - inset) * 2.0;
	
	// Since we can, why not precalculate this too.
	tang = 0.5 / tang;
	
}


void fragment(){
	// p is a vector from camera origo to camera nearplane.
	vec3 p = vec3(UV - 0.5, tang);
	vec3 plane_offset = vec3(vec2(0.5) - rotation_pivot, tang + 1.);
	vec3 plane_normal = rotmat[2];
	
    float dot_prod = dot(plane_normal, p);
	if (dot_prod <= 0.0) discard;
	
    float fac = dot(plane_normal, plane_offset) / dot_prod;
	vec2 uv = (inverse(rotmat) * (p * fac - plane_offset)).xy;
	
	uv += vec2(0.5) - rotation_pivot;
	if (any(greaterThan(abs(uv), vec2(0.5)))) discard;
	
	COLOR = texture(TEXTURE, uv + 0.5);
}