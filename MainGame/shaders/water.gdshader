shader_type canvas_item;
render_mode blend_mix;

uniform vec4 color : source_color = vec4(0.0, 0.0, 1.0, 0.5);
uniform float speed = 0.2;

float random (vec2 uv) {
	return fract(sin(dot(uv,vec2(12.9898,78.233)))*43758.5453123);
}

void fragment()
{	
	float generatedrandom = random(UV);
	vec2 uvoffset;
	if (generatedrandom < 0.25) {
		uvoffset = vec2(speed, speed) * TIME;
	}
	else if (generatedrandom < 0.5) {
		uvoffset = vec2(speed, -speed) * TIME * 2.0 * speed;
	}
	else if (generatedrandom < 0.75) {
		uvoffset = vec2(-speed, speed) * TIME;
	}
	else {
		uvoffset = vec2(-speed, speed) * TIME * 2.0 * speed;
	}

	COLOR = texture(TEXTURE, UV + uvoffset);
	COLOR.rgb = max(COLOR.rgb, vec3(0.5, 0.5, 0.5));
	COLOR.rgb *= color.rgb;
	COLOR.a = color.a;
}