@tool
class_name realease_soulorb
extends BTAction

var wizard:Wizard

func _setup() -> void:
	wizard = agent as Wizard
	
func _tick(_delta: float) -> Status:
	if wizard.soulorb!=null && wizard.laser == null:
		wizard.release_soulorb()
		return SUCCESS
	if wizard.soulorb == null:
		return SUCCESS
		
	return RUNNING
