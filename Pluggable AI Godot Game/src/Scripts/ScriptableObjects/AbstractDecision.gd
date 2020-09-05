"""
Decision super class for all decisions
Inherited by:
	[ActiveStateDecision, LookDecision, ScanDecision]
"""
extends Resource
class_name AbstractDecision, 'res://assets/icons/decision-icon.svg'


export var debugDrawColor := Color.white # Debug
export var resourceName := 'Decision'    # Debug


func decide(controller : StateController) -> bool:
	return false
