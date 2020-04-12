extends Node2D


onready var windowSize := self.get_viewport_rect().size
onready var camera := $Camera2D as Camera2D

var targets := []


func _ready() -> void:
	camera.limit_right = windowSize.x
	camera.limit_bottom = windowSize.y


func _process(delta: float) -> void:
	if targets.size() <= 1:
		camera.zoom = lerp(camera.zoom, Vector2.ONE, 2.0 * delta)
		return
	
	var minPos := windowSize
	var maxPos := Vector2.ZERO
	for target in targets:
		if target.global_position.x < minPos.x:
			minPos.x = target.global_position.x
		if target.global_position.x > maxPos.x:
			maxPos.x = target.global_position.x
		if target.global_position.y < minPos.y:
			minPos.y = target.global_position.y
		if target.global_position.y > maxPos.y:
			maxPos.y = target.global_position.y
	self.global_position = lerp(self.global_position, (maxPos + minPos) / 2, 2.0 * delta)
	
	var zoom = 2.0 * max((maxPos.x - minPos.x) / windowSize.x, (maxPos.y - minPos.y) / windowSize.y)
	zoom = clamp(zoom, 0.5, 1.0)
	camera.zoom = lerp(camera.zoom, Vector2.ONE * zoom, 2.0 * delta)
