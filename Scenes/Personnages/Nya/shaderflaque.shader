shader_type canvas_item;
uniform vec2 scale;
uniform float zoom;

void fragment() {
	vec4 OutTexture;
	float UVh = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	vec2 UVr = vec2(SCREEN_UV.x, SCREEN_UV.y + UVh * UV.y * 2.0 * (1.0/zoom) * 3.9);
 	OutTexture = texture(SCREEN_TEXTURE, UVr).rgba;
	OutTexture.rgb = OutTexture.rgb/3.0 + texture(SCREEN_TEXTURE, SCREEN_UV).rgb/3.0 + texture(TEXTURE, UV).rgb/3.0;
	OutTexture = vec4(OutTexture.rgb, texture(TEXTURE, UV).a);
	COLOR = OutTexture; 
}
/*
void fragment() {
	vec4 OutTexture;
	float UVh = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	vec2 UVr = vec2(SCREEN_UV.x, SCREEN_UV.y + UVh * UV.y * (2.0 * zoom));
 	OutTexture = texture(SCREEN_TEXTURE, UVr).rgba;
	OutTexture = vec4(OutTexture.rgb, texture(TEXTURE, UV).a);
	COLOR = OutTexture; 
}*/