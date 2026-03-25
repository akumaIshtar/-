
class_name BloodEmitter
extends Node2D

var blood:GPUParticles2D

func _ready():
	blood = find_child("Blood")
	blood.emitting = true


	
