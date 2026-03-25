shader_type canvas_item;

// 渐变参数
uniform vec4 start_color : source_color = vec4(0.8, 0.2, 0.8, 1.0); // 起点颜色(紫)
uniform vec4 end_color : source_color = vec4(0.2, 0.8, 1.0, 1.0);   // 终点颜色(蓝)

void fragment() {
	// 获取线段上的相对位置(0=起点, 1=终点)
	float gradient_pos = UV.x;

	// 颜色混合
	COLOR = mix(start_color, end_color, gradient_pos);
}