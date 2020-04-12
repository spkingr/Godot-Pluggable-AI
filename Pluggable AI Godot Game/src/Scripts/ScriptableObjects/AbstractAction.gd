"""
Action super class for all actions
Inherited by:
	[AttackAction, ChaseAction, PatrolAction]
"""
extends Resource
class_name AbstractAction, 'res://assets/icons/action-icon.svg'


export var debugDrawColor := Color.black # Debug
export var resourceName := 'Action'      # Debug


func act(controller : StateController) -> void:
	pass
