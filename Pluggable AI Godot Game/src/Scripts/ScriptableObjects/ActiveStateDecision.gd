extends AbstractDecision
class_name ActiveStateDecision


func decide(controller : StateController) -> bool:
	.decide(controller)
	return controller.hasChaseTarget()
