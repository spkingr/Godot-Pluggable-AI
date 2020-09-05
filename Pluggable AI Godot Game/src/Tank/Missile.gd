extends Area2D


const MissileExplosionScene := preload('res://src/Tank/MissileExplosion.tscn')


export var missileBodyMaxOffset := 60.0
export(float, 1.0, 10.0) var shadowMaxScale := 1.5
export(float, 0.0, 1.0) var shadowMinScale := 0.5
export(float, 0.0, 1.0) var shadowMinAlpha := 0.25
export(float, 1.0, 2.0) var shadowMaxAlpha := 2.5
export var collisionDetectionError := 1

onready var _body := $Body as Node2D
onready var _shadow := $Shadow as Sprite

var _direction := Vector2.ZERO
var _velocityX := 0.0
var _velocityY := 0.0
var _fullSpeed := 600
var _moveResistance := 400.0

var _maxFlyHeight := 0.0
var _paramScaleA := 0.0
var _paramScaleB := 0.0
var _paramAlphaA := 0.0
var _paramAlphaB := 0.0

var currentHeight := 0.0
var isExploded := false


func init(force : float, maxSpeed : int, resistance : int, dir : Vector2) -> void:
	_direction = dir
	_fullSpeed = maxSpeed
	_moveResistance = resistance
	
	_maxFlyHeight = 0.5 * maxSpeed * maxSpeed / resistance
	_paramScaleA = (shadowMinScale - shadowMaxScale) / _maxFlyHeight
	_paramScaleB = shadowMaxScale
	_paramAlphaA = (shadowMaxAlpha - shadowMinAlpha) / (shadowMinScale - shadowMaxScale)
	_paramAlphaB = shadowMaxAlpha - shadowMinScale * _paramAlphaA
	
	var angle = fmod(dir.angle(), 2 * PI)
	if angle > PI * 0.5 || angle < - PI * 0.5:
		missileBodyMaxOffset = -missileBodyMaxOffset
	
	# Angle = 45deg
	_velocityX = force * maxSpeed
	_velocityY = force * maxSpeed


func _ready() -> void:
	self.rotation = _direction.angle()


func _physics_process(delta: float) -> void:
	self.position += _direction * _velocityX * delta
	_velocityY -= _moveResistance * delta
	currentHeight += _velocityY * delta
	_adjustHeight(currentHeight)
	if currentHeight <= 0.0:
		explode()


func _adjustHeight(height : float) -> void:
	_body.position.y = - height / _maxFlyHeight * missileBodyMaxOffset
	var shadowScale = _paramScaleA * height + _paramScaleB
	_shadow.scale = Vector2.ONE * shadowScale
	var shadowAlpha = _paramAlphaA * shadowScale + _paramAlphaB
	_shadow.modulate.a = shadowAlpha


func _on_Missile_area_entered(area: Area2D) -> void:
	if isExploded:
		return
		
	if is_instance_valid(area) && area.is_in_group('bullet'):
		if currentHeight - area.currentHeight <= collisionDetectionError:
			explode()
			area.explode()


func _on_Missile_body_entered(body: Node) -> void:
	if isExploded:
		return
		
	if is_instance_valid(body) && body.is_in_group('player'):
		if currentHeight <= collisionDetectionError:
			explode()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	self.queue_free()


func explode() -> void:
	if isExploded:
		return
	isExploded = true
	
	var explosion = MissileExplosionScene.instance()
	self.get_parent().add_child(explosion)
	explosion.global_position = self.global_position
	
	self.queue_free()

