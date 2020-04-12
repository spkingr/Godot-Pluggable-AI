"""
This is the State Resource, or ScriptableObject in Unity
Created resource by State:
	[AlertScanner, ChaseChaser, ChaseScanner, PatrolChaser, PatrolScanner, RemainState]
"""
extends Resource
class_name State, 'res://assets/icons/state-icon.svg'


export(Array, Resource) var actions = []       # AbstractAction
export(Array, Resource) var transitions = []   # Transitions
export var debugStateColor := Color.green      # Debug Draw Color

export var resourceName := 'State'             # Debug Name


func updateState(controller : StateController) -> void:
	_doActions(controller)
	_checkTransitions(controller)


func _doActions(controller : StateController) -> void:
	for action in actions:
		action.act(controller)


func _checkTransitions(controller : StateController) -> void:
	for transition in transitions:
		var decisionSucceeded : bool = transition.decision.decide(controller)
		if decisionSucceeded:
			var trueState = transition.trueState
			if trueState == null:
				trueState = load(transition.trueStateResource)
				transition.trueState = trueState
			controller.transitionToState(trueState)
		else:
			var falseState = transition.falseState
			if falseState == null:
				falseState = load(transition.falseStateResource)
				transition.falseState = falseState
			controller.transitionToState(falseState)
