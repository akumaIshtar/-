shader_type canvas_item;
render_mode blend_add;

// 动态参数 (需从脚本同步)
uniform float line_length : hint_range(0,1) = 1.0; // 线段长度比例 [1](@ref)
uniform float line_width : hint_range(0,0.2) = 0.02; // 线宽比例 [1](@ref)
uniform float energy : hint_range(0,5) = 3.0; 
uniform int beams : hint_range(1,8) = 2; // 光束数量 [1,6](@ref)

// 视觉参数 (可编辑器调整)
uniform vec4 color = vec4(0.91,1.0,1.0,1.0);
uniform vec4 outline_color = vec4(0.5,1.0,0.96,1.0);
uniform float thickness : hint_range(0.0,0.1) = 0.006;
uniform float outline_thickness : hint_range(0.0,0.1) = 0.03;

// 噪声参数
uniform int roughness : hint_range(1,10) = 3;
uniform int frequency : hint_range(1,30) = 10;
uniform vec2 noise_scale = vec2(1.0,0.5); // 纵向压缩补偿 [1](@ref)

// 动画参数
uniform float progress : hint_range(0.0,1.0) = 1.0;
uniform float y_offset : hint_range(-0.5,0.5) = 0.0;

// 核心噪声函数 (网页5的星空噪声改进版)
float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = smoothstep(0.0,1.0,f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// 分形布朗运动 (网页4的FBM实现)
float fbm(vec2 uv, float time) {
    float value = 0.0;
    float amp = 0.5;
    float freq = float(frequency);
    
    for(int i=0; i<roughness; i++) {
        value += amp * noise(uv * freq + vec2(time));
        amp *= 0.5;
        freq *= 2.0;
    }
    return value * energy * progress;
}

// 光束生成核心 (结合网页1的UV映射)
vec4 bolt(vec2 uv, float time, float i) {
    // 纵向缩放适配线段长度 [1](@ref)
    uv.y *= line_length; 
    uv *= noise_scale;
    
    // 边缘衰减 (网页5的边界处理)
    float edge = smoothstep(0.0, 0.05, uv.x) * smoothstep(1.0, 0.95, uv.x);
    
    // 动态厚度计算 (网页6的uniform同步)
    float actual_thickness = thickness * (1.0 - (float(i)/float(beams)) * 0.5);
    float noise_val = fbm(uv + vec2(i*0.3), time) * edge;
    
    // 主光束核心
    float main_beam = smoothstep(actual_thickness, actual_thickness+0.005, noise_val);
    float outline = smoothstep(actual_thickness - outline_thickness, actual_thickness, noise_val);
    
    // 颜色混合 (网页2的Decal混合思路)
    vec4 final_color = mix(outline_color, color, main_beam);
    final_color.a *= smoothstep(0.95, 1.0, uv.y); // 尾部渐隐
    
    return final_color * progress;
}

void fragment() {
    vec4 final = vec4(0.0);
    for(int i=0; i<beams; i++) {
        // 多光束偏移 (网页5的时间动画)
        float offset = float(i) * 0.1 * line_width;
        final += bolt(UV + vec2(0.0, offset), TIME, float(i));
    }
    COLOR = final * (1.0 - smoothstep(0.8,1.0,UV.y)); // 顶部衰减
}