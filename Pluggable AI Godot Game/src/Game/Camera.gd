extends Node2D


onready var _windowSize := self.get_viewport_rect().size
onready var _camera := $Camera2D as Camera2D

var targets := []


func _ready() -> void:
	_camera.limit_right = _windowSize.x
	_camera.limit_bottom = _windowSize.y


func _process(delta: float) -> void:
	if targets.size() <= 1:
		_camera.zoom = lerp(_camera.zoom, Vector2.ONE, 2.0 * delta)
		return
	
	var minPos := _windowSize
	var maxPos := Vector2.ZERO
	for target in targets:
		if ! is_instance_valid(target):
			continue
		if target.global_position.x < minPos.x:
			minPos.x = target.global_position.x
		if target.global_position.x > maxPos.x:
			maxPos.x = target.global_position.x
		if target.global_position.y < minPos.y:
			minPos.y = target.global_position.y
		if target.global_position.y > maxPos.y:
			maxPos.y = target.global_position.y
	self.global_position = lerp(self.global_position, (maxPos + minPos) / 2, 2.0 * delta)
	
	var zoom = 2.0 * max((maxPos.x - minPos.x) / _windowSize.x, (maxPos.y - minPos.y) / _windowSize.y)
	zoom = clamp(zoom, 0.5, 1.0)
	_camera.zoom = lerp(_camera.zoom, Vector2.ONE * zoom, 2.0 * delta)
