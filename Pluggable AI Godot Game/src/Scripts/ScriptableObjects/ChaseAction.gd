extends AbstractAction
class_name ChaseAction


func act(controller : StateController) -> void:
	.act(controller)
	_chase(controller)


func _chase(controller : StateController) -> void:
	controller.pauseNavigation(false)
