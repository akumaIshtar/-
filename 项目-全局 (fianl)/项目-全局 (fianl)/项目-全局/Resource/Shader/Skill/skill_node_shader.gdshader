shader_type canvas_item;

// 共用参数
uniform bool is_unlocked;
uniform float feather_radius : hint_range(0, 1) = 0.8; // 羽化起始半径(0.8=80%处开始)
uniform float edge_alpha : hint_range(0, 1) = 0.3;    // 最边缘透明度

// 未解锁参数
uniform float locked_brightness : hint_range(0, 1) = 0.4;
uniform vec4 locked_tint : source_color = vec4(0.5, 0.5, 1.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float dist = distance(UV, vec2(0.5)) * 2.0; // 中心距离(0~1)

    // 核心逻辑
    if (dist > feather_radius) {
        // 边缘区域：所有状态都羽化
        float alpha = mix(
            is_unlocked ? 1.0 : locked_brightness, // 内边缘透明度
            edge_alpha,                            // 最边缘透明度
            smoothstep(feather_radius, 1.0, dist)  // 羽化强度
        );
        COLOR.a = tex_color.a * alpha;
    } else {
        // 中心区域：未解锁时强制不透明
        COLOR.a = tex_color.a * (is_unlocked ? 1.0 : 1.0);
    }

    // 颜色处理
    COLOR.rgb = tex_color.rgb * (is_unlocked ? vec3(1.0) : locked_tint.rgb * locked_brightness);
}