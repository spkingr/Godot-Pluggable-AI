extends Area2D


export var maxDamage := 20
export var maxForce := 1000.0

onready var damageRange : float = $CollisionShape2D.shape.radius


func _on_Explosion_body_entered(body: Node) -> void:
	if body.has_method('damaged'):
		var vector : Vector2 = body.global_position - self.global_position
		var ratio : float = 1.0 - pow(vector.length() / damageRange, 0.6)
		var damage := ceil(maxDamage * ratio)
		var force : Vector2 = maxForce * ratio * vector.normalized()
		body.damaged(damage, force)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	self.queue_free()
