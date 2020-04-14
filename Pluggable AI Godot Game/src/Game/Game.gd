extends Node2D


const TankExplosionScene := preload('res://src/Tank/TankExplosion.tscn')

export var stopCamera := true # Debug

onready var wayPointsNode := $Waypoints as Node2D
onready var camera := $Camera as Node2D
onready var tankContainer := $Tanks as Node2D
onready var gameoverScreen := $CanvasLayer/GameOverScreen as Control


func _ready() -> void:
	gameoverScreen.setMessage('You Win!')
	gameoverScreen.hide()
	
	for tank in tankContainer.get_children():
		if tank is Tank:
			tank.connect('dead', self, '_on_Tank_dead', [tank])
	
	if stopCamera:
		camera.targets = []
	else:
		camera.targets = tankContainer.get_children()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('reload'):
		self.get_tree().reload_current_scene()


func _on_StateController_getWayPoints(stateController : StateController) -> void:
	if wayPointsNode == null:
		yield(self, 'ready')
	
	var points := []
	for node in wayPointsNode.get_children():
		points.append(node.global_position)
	stateController.wayPointsList = points


func _on_Tank_dead(tank : Tank) -> void:
	var explosion = TankExplosionScene.instance()
	self.add_child(explosion)
	explosion.global_position = tank.global_position
	
	camera.targets.erase(tank)
	
	if tank.name == 'TankPlayer':
		gameoverScreen.setMessage('You Lost!')
	
	if self.get_tree().get_nodes_in_group('player').size() <= 2:
		gameoverScreen.show()

