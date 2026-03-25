shader_type canvas_item;

uniform float rotation_speed = 2.0;   // 适当提高默认速度，便于观察
uniform float glow_intensity = 3.0;
uniform float center_transparency = 0.3;
uniform float arc_width = 0.2;         // 弧形光效宽度
uniform float arc_intensity = 0.8;     // 弧形光效强度
uniform float particle_count = 20.0;   // 粒子数量
uniform float particle_speed = 0.1;    // 粒子移动速度

// 随机数生成函数
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    vec2 original_uv = UV - vec2(0.5);  // 原始坐标（未旋转）
    float angle = TIME * rotation_speed; // 随时间变化的旋转角度

    // 手动计算旋转后的坐标
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);
    float rotated_x = original_uv.x * cos_angle - original_uv.y * sin_angle;
    float rotated_y = original_uv.x * sin_angle + original_uv.y * cos_angle;
    vec2 rotated_uv = vec2(rotated_x, rotated_y);

    float dist = length(rotated_uv);     // 距离基于旋转后的坐标

    // 圆形掩码：超出半径 0.5 的区域完全透明
    float is_inside = step(dist, 0.5);

    // 2. 立体感：基于旋转后的坐标计算（关键！）
    float depth = sqrt(1.0 - dot(rotated_uv, rotated_uv));
    depth = clamp(depth, 0.0, 1.0);

    // 3. 边缘发光：基于旋转后的距离
    float glow = smoothstep(0.4, 0.5, dist);
    glow = pow(glow, glow_intensity);

    // 4. 中间透明度：基于旋转后的距离
    float transparency = smoothstep(0.0, center_transparency, dist);
    transparency *= is_inside;          // 外部完全透明

    // 5. 弧形光效：基于旋转后的角度（增强旋转视觉）
    float current_angle = atan(rotated_uv.y, rotated_uv.x);  // 旋转后的角度
    float arc_center_angle = angle;                          // 光效中心随旋转同步
    float arc_distance = abs(mod(current_angle - arc_center_angle + 3.14159, 2.0 * 3.14159) - 3.14159);
    float arc = smoothstep(arc_width / 2.0, 0.0, arc_distance);
    arc = clamp(arc * arc_intensity, 0.0, 1.0);              // 限制强度范围

    // 粒子效果
    float particle_effect = 0.0;
    for (float i = 0.0; i < particle_count; i++) {
        // 随机生成粒子的初始位置
        vec2 particle_pos = vec2(random(vec2(i, 0.0)), random(vec2(i, 1.0))) - 0.5;
        // 粒子的移动
        vec2 moving_particle_pos = particle_pos + vec2(cos(TIME * particle_speed + i), sin(TIME * particle_speed + i)) * 0.05;
        // 计算当前片段到粒子的距离
        float particle_dist = length(rotated_uv - moving_particle_pos);
        // 粒子的半径
        float particle_radius = 0.01;
        // 如果当前片段在粒子半径内，添加粒子效果
        if (particle_dist < particle_radius) {
            particle_effect = 1.0;
        }
    }

    // 最终颜色：发光 + 立体感 + 弧形光效 + 粒子效果
    vec3 color = vec3(1.0, 0.9, 0.8) * (glow * depth + arc + particle_effect);  // 轻微暖色调光效
    COLOR = vec4(color, transparency);
}
