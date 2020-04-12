extends AbstractDecision
class_name LookDecision


func decide(controller : StateController) -> bool:
	.decide(controller)
	var isTargetVisible := _look(controller)
	return isTargetVisible


func _look(controller : StateController) -> bool:
	var dir = controller.global_transform.x
	var from = controller.global_position
	var to = from + dir * controller.enemyStatus.lookRange
	controller.drawLine(from, to, self.debugDrawColor)
	
	var spaceState : Physics2DDirectSpaceState = controller.get_world_2d().direct_space_state
	var exclude := [controller, controller.get_parent()]
	for i in [-1, 0, 1]:
		var normal = dir.rotated(controller.enemyStatus.lookAngle / 2 * i)
		var result := spaceState.intersect_ray(from, from + normal * controller.enemyStatus.lookRange, exclude)
		if result && result.collider.is_in_group('player'):
			controller.chaseTarget = result.collider
			return true
	
	return false
