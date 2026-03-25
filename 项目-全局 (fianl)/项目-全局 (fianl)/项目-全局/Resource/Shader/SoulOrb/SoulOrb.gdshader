shader_type canvas_item;


uniform vec2 center_offset = vec2(0.01, -0.01); // 基于512px尺寸的8像素偏移
uniform float effect_radius : hint_range(0.1, 1.0) = 0.18;
uniform float node_scale:hint_range(0.0,5.0) = 1.0;
uniform float modulate_a:hint_range(0.0, 1.0) = 1.0;

uniform float flow_speed : hint_range(0, 20) = 1.0;
uniform float noise_scale : hint_range(0, 2) = 0.5;
uniform sampler2D noise_tex;
uniform sampler2D erosion_mask;
uniform vec3 core_color : source_color = vec3(0.7, 0.1, 0.1);
uniform vec3 highlight_color : source_color = vec3(0.9, 0.3, 0.3);

void fragment() {
	
	float scale_radius = effect_radius/node_scale;
	vec2 scale_offset = vec2(center_offset.x*node_scale,center_offset.y*node_scale);
	
    // ======= 中心点偏移计算 =======
    vec2 base_center = vec2(0.5) + scale_offset; // 基础中心偏移[5](@ref)
    vec2 centered_uv = (UV - base_center) * 2.0;
    float radius = length(centered_uv);
    float angle = atan(centered_uv.y, centered_uv.x);
    
    // ======= 动态范围控制 =======
    float range_mask = smoothstep(scale_radius, scale_radius - 0.1, radius);

    // ======= 偏移后的扭曲计算 =======
    vec2 flow_uv = vec2(
        radius * cos(angle + TIME * flow_speed * (1.0 - radius)),
        radius * sin(angle + TIME * flow_speed * (1.0 - radius))
    ) * 0.5 + base_center; // 应用新中心点[6](@ref)
    
    flow_uv = mix(UV, flow_uv, range_mask);

    // ======= 噪声采样优化 =======
    vec4 noise1 = texture(noise_tex, flow_uv * noise_scale * range_mask);
    vec4 noise2 = texture(noise_tex, flow_uv * noise_scale * 1.8 * range_mask);
    float noise_blend = (noise1.r + noise2.g) * 0.5 * range_mask;

    // ======= 精确流动效果 =======
    vec2 distorted_uv = UV + (noise1.rg - 0.5) * 0.1 * range_mask;
    vec4 base_color = texture(TEXTURE, distorted_uv);

    // ======= 颜色分层处理 =======
    vec3 dynamic_core = mix(core_color, highlight_color, noise_blend * 0.8);
    vec3 final_color = mix(base_color.rgb, dynamic_core, 
        smoothstep(0.3, 0.6, radius) * range_mask);

    // ======= 边缘处理强化 =======
    float edge_mask = smoothstep(scale_radius - 0.05, scale_radius, radius);
    final_color = mix(final_color, vec3(0.0), edge_mask);

    COLOR = vec4(final_color, base_color.a*modulate_a);
}