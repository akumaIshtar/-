shader_type canvas_item;

uniform float progress : hint_range(0, 1) = 0.0;
uniform vec4 shadow_color : source_color = vec4(0.0, 0.0, 0.0, 0.6);
uniform float edge_smoothness : hint_range(0, 0.2) = 0.02;
uniform float flash_progress : hint_range(0, 1) = 0.0; // 新增：闪烁进度(0=未触发，1=完成)

void fragment() {
	// 基础颜色
	vec4 tex_color = texture(TEXTURE, UV);

	// 冷却阴影（自上而下）
	float shadow_mask = smoothstep(UV.y, UV.y + edge_smoothness, progress);
	vec3 base_color = mix(tex_color.rgb, shadow_color.rgb, shadow_mask * shadow_color.a);

	// 冷却结束时的闪烁效果（白色闪光）
	float flash_intensity = smoothstep(0.4, 0.0, abs(flash_progress - 1.0) * 2.0);
	vec3 flash_color = mix(base_color, vec3(1.0), flash_intensity * 0.8);

	COLOR = vec4(flash_color, tex_color.a);
}