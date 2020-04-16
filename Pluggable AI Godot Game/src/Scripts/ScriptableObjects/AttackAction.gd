extends AbstractAction
class_name AttackAction


func act(controller : StateController) -> void:
	.act(controller)
	_attack(controller)


func _attack(controller : StateController) -> void:
	var dir = controller.global_transform.x
	var from = controller.global_position
	var to = from + dir * controller.enemyStatus.attackRange
	controller.drawLine([from], [to], self.debugDrawColor, 4.0)
	
	var attackRange = controller.enemyStatus.attackRange + rand_range(0.0, controller.enemyStatus.attackRangeRandom)
	var attackRage = controller.enemyStatus.attackRate + rand_range(0.0, controller.enemyStatus.attackRateRandom)
	if controller.checkIfCountDownElapsed(attackRage):
		var spaceState : Physics2DDirectSpaceState = controller.get_world_2d().direct_space_state
		var exclude := [controller, controller.get_parent()]
		var result := spaceState.intersect_ray(from, from + dir * attackRange, exclude)
		if result && result.collider.is_in_group('player'):
			var force := rand_range(controller.enemyStatus.attackForceMin, controller.enemyStatus.attackForceMax)
			controller.fire(force)
