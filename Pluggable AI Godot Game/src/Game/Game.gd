extends Node2D


const ExplosionScene := preload('res://src/Tank/Explosion.tscn')

export var stopCamera := true # Debug

onready var wayPointsNode := $Waypoints as Node2D
onready var camera := $Camera as Node2D
onready var tankContainer := $Tanks as Node2D


func _ready() -> void:
	$CanvasLayer/GameOverScreen.hide()
	
	for tank in tankContainer.get_children():
		tank.connect('dead', self, '_on_Tank_dead', [tank])
	
	if stopCamera:
		camera.targets = []
	else:
		camera.targets = tankContainer.get_children()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('reload'):
		self.get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if tankContainer.get_child_count() <= 1:
		$CanvasLayer/GameOverScreen.show()


func _on_StateController_getWayPoints(stateController : StateController) -> void:
	if wayPointsNode == null:
		yield(self, 'ready')
	
	var points := []
	for node in wayPointsNode.get_children():
		points.append(node.global_position)
	stateController.wayPointsList = points


func _on_Tank_dead(tank : Tank) -> void:
	var explosion = ExplosionScene.instance()
	self.add_child(explosion)
	explosion.global_position = tank.global_position
	
	camera.targets.erase(tank)

