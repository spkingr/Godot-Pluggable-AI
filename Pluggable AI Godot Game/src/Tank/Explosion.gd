extends Area2D


export var maxDamage := 20
export var maxForce := 1000.0

onready var damageRange : float = $CollisionShape2D.shape.radius


func _on_Explosion_body_entered(body: Node) -> void:
	if body.has_method('damaged'):
		var ratio := self.global_position.distance_to(body.global_position) / damageRange
		var damage := int(maxDamage * (1.0 - pow(ratio, 3)))
		var force : Vector2 = maxForce * ratio * (body.global_position - self.global_position).normalized()
		body.damaged(damage, force)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	self.queue_free()
