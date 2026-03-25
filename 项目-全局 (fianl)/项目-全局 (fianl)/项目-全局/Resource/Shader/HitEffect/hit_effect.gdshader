shader_type canvas_item;

uniform float hit_time:hint_range(0.0, 1.0)=0.0;
uniform float shake = 0;
uniform vec4 hit_color:source_color = vec4(1.0,0.3,0.3,1.0);


void vertex() {
	//顶点抖动效果
	VERTEX.x +=sin(TIME*30.0)*0.1*hit_time;
	VERTEX.y += cos(TIME*25.0)*0.1*hit_time;
	//叠加受击抖动效果
	VERTEX.xy +=vec2(shake,shake)*hit_time;
}

void fragment() {
    // 基础颜色混合
	vec4 base_color = texture(TEXTURE,UV);
    float flash = sin(TIME * 15.0) * 0.5 + 0.5;
    vec3 final_color = mix(base_color.rgb, hit_color.rgb, flash * hit_time);
	COLOR = vec4(final_color,0.7);

}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
