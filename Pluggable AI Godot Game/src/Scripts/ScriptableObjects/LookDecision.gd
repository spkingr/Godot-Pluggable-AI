extends AbstractDecision
class_name LookDecision


func decide(controller : StateController) -> bool:
	.decide(controller)
	var isTargetVisible := _look(controller)
	return isTargetVisible


func _look(controller : StateController) -> bool:
	var h := float(controller.getParentShapeSideLength())
	var angle := asin(h / controller.enemyStatus.lookRange)
	var n := int(deg2rad(controller.enemyStatus.lookAngle) / angle + 0.5)
	
	var dir = controller.global_transform.x.normalized()
	var from = controller.global_position
	var to = from + dir * controller.enemyStatus.lookRange
	var froms := []
	var tos := []
	for i in range(-n, n + 1, 2):
		froms.append(from)
		tos.append(from + dir.rotated(deg2rad(controller.enemyStatus.lookAngle / 2 / n * i)) * controller.enemyStatus.lookRange)
	controller.drawLine(froms, tos, self.debugDrawColor)
	
	var spaceState : Physics2DDirectSpaceState = controller.get_world_2d().direct_space_state
	var exclude := [controller, controller.get_parent()]
	for i in range(-n, n + 1, 2):
		var normal = dir.rotated(deg2rad(controller.enemyStatus.lookAngle / 2 / n * i))
		var result := spaceState.intersect_ray(from, from + normal * controller.enemyStatus.lookRange, exclude)
		if result && result.collider.is_in_group('player'):
			controller.chaseTarget = result.collider
			return true
	
	return false
