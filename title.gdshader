shader_type canvas_item;
render_mode unshaded;
uniform sampler2D gradient : source_color;

uniform float gradient_mix_amount = 1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 gradientTex = texture(gradient, UV).rgb;
	COLOR.rgb = gradientTex;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
