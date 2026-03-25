class_name PuperFog
extends Node2D

var puperfog:GPUParticles2D

func _ready():
	puperfog = find_child("PuperFog")
	puperfog.emitting = true
