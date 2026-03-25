@tool
extends BTAction

var wizard:Wizard

func _setup() -> void:
	wizard = agent as Wizard

func _enter() -> void:
	wizard.generate_laser_ray()

func _tick(_delta: float) -> Status:
	
	if wizard.laser!=null:
		
		return SUCCESS
	else:
		return FAILURE
