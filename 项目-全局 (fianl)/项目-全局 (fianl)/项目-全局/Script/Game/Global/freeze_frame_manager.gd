
extends Node2D

const DEFAULT_DURATION = 0.05
const DEFAULT_TIME_SCALE = 0.3


	
func trigger(duration:=DEFAULT_DURATION,time_scale:=DEFAULT_TIME_SCALE)->void:
	Engine.time_scale = time_scale
	await get_tree().create_timer(duration,true,false,true).timeout
	Engine.time_scale =1.0
