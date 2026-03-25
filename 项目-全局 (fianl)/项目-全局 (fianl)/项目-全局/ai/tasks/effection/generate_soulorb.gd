@tool
extends BTAction

var wizard:Wizard

func _setup() -> void:
	wizard = agent as Wizard

func _tick(_delta: float) -> Status:
	wizard.generate_soulorb()
	
	if wizard.soulorb!=null:
		
		return SUCCESS
	else:
		return FAILURE
