extends AbstractAction
class_name PatrolAction


func act(controller : StateController) -> void:
	.act(controller)
	_patrol(controller)


func _patrol(controller : StateController) -> void:
	controller.chaseTarget = null
	controller.pauseNavigation(false)
	
	if controller.wayPointsList.empty():
		return
	
	var isArrived := controller.moveToPoint(controller.nextPointIndex, controller.enemyStatus.moveSpeed)
	if isArrived:
		var i = controller.nextPointIndex + 1 if randf() < 0.75 else randi()
		controller.nextPointIndex = i % controller.wayPointsList.size()
