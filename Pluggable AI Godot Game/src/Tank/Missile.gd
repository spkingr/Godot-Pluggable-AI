extends Area2D


const ExplosionScene := preload('res://src/Tank/Explosion.tscn')

export var moveSpeed := 600
export var moveResistance := 200

var _direction := Vector2.ZERO
var _speed := 0.0


func init(force : float, dir : Vector2) -> void:
	_direction = dir
	_speed = moveSpeed * force


func _ready() -> void:
	self.rotation = _direction.angle()
	moveResistance += rand_range(-100, 100)


func _physics_process(delta: float) -> void:
	_speed -= moveResistance * delta
	if _speed <= 0.0:
		_explode()
	else:
		self.position += _direction * _speed * delta


func _explode() -> void:
	var explosion = ExplosionScene.instance()
	self.get_parent().add_child(explosion)
	explosion.global_position = self.global_position
	
	self.queue_free()


func _on_Missile_area_entered(area: Area2D) -> void:
	_explode()


func _on_Missile_body_entered(body: Node) -> void:
	_explode()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	self.queue_free()



