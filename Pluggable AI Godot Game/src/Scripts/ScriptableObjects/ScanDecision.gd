extends AbstractDecision
class_name ScanDecision


func decide(controller : StateController) -> bool:
	.decide(controller)
	var noEnemyInSight := _scan(controller)
	return noEnemyInSight


func _scan(controller : StateController) -> bool:
	controller.pauseNavigation()
	controller.setTurnSpeed(controller.enemyStatus.searchTurnSpeed)
	return controller.checkIfCountDownElapsed(controller.enemyStatus.searchDuration)

