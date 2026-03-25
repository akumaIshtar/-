shader_type spatial;

// 定义斩击的进度，范围从 0 到 1
uniform float slash_progress = 0.0;
// 定义斩击的主颜色
uniform vec4 slash_color @export(COLOR) = vec4(1.0, 1.0, 1.0, 1.0);
// 定义斩击的边缘颜色
uniform vec4 edge_color @export(COLOR) = vec4(0.2, 0.2, 0.2, 1.0);
// 定义斩击的宽度
uniform float slash_width = 0.1;
// 定义斩击的边缘宽度
uniform float edge_width = 0.05;
// 引入噪声纹理，增加随机感
uniform sampler2D noise_texture;

void fragment() {
    // 获取当前片段的 UV 坐标
    vec2 uv = UV;
    // 计算斩击的中心位置，这里简单地让斩击从左到右移动
    float slash_center = slash_progress;
    // 计算当前片段到斩击中心的距离
    float dist = abs(uv.x - slash_center);

    // 计算主斩击的透明度
    float main_alpha = smoothstep(slash_width, 0.0, dist);
    // 计算边缘斩击的透明度
    float edge_alpha = smoothstep(slash_width + edge_width, slash_width, dist);

    // 从噪声纹理中采样噪声值
    float noise = texture(noise_texture, uv * 5.0).r;

    // 混合主斩击颜色和边缘斩击颜色
    vec4 main_color = mix(TEXTURE(SCREEN_TEXTURE, uv), slash_color, main_alpha * slash_color.a);
    vec4 edge_final_color = mix(main_color, edge_color, edge_alpha * edge_color.a * noise);

    // 输出最终颜色
    ALBEDO = edge_final_color.rgb;
    ALPHA = edge_final_color.a;
}    