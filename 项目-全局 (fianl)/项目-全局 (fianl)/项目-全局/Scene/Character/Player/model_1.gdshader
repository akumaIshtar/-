shader_type canvas_item;
// 定义Uniform变量控制透明度和发光强度
uniform float alpha = 0.5;
uniform float glow_power = 1.5;
uniform vec4 glow_color = vec4(1.0, 0.8, 0.3, 1.0); // 默认发光颜色为橙色

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    // 计算亮度（基于RGB的加权平均值）
    float brightness = dot(base_color.rgb, vec3(0.2126, 0.7152, 0.0722));
    // 根据亮度叠加发光颜色
    vec4 glow = glow_color * brightness * glow_power;
    // 混合基础颜色和发光颜色
    base_color = mix(base_color, base_color + glow, brightness);
    base_color.a *= alpha;
    COLOR = base_color;
}