extends KinematicBody2D
class_name Tank


signal dead()


const MissileScene := preload('res://src/Tank/Missile.tscn')
const ACCELERATION := 80.0
const DECELERATION := -160.0

export var moveSpeed := 200
export var rotateSpeed := 1.25
export var tankBodyRect := Rect2(216, 0, 42, 42)
export var tankGunRect := Rect2(326, 264, 16, 30)
export var tankFireRect := Rect2(324, 295, 21, 39)

export var missileMoveSpeed := 400
export var missileMoveResistance := 300

onready var animationPlayer := $AnimationPlayer as AnimationPlayer
onready var cooldownTimer := $FireCooldownTimer as Timer
onready var attackedTimer := $AttackedCooldownTimer as Timer
onready var firePosition := $FirePoint as Position2D
onready var fireSprite := $SpriteFire as Sprite
onready var gunSprite := $SpriteGun as Sprite
onready var bodySprite := $SpriteBody as Sprite
onready var collisionShape := $CollisionShape2D.shape as Shape2D
onready var healthBar = $HealthBar
onready var powerIndicator = $PowerIndicator

var _isAIActive := false
var _stateTimeElapsed := 0.0

var _canFire := true
var _speed := 0.0
var _acceleration := 0.0
var _moveDir := Vector2.ZERO
var _rotateDir := 0.0
var _isAttacked := false

var health := 100
var isDead := false
var sideLength := 0


func _ready() -> void:
	fireSprite.hide()
	fireSprite.region_rect = tankFireRect
	gunSprite.region_rect = tankGunRect
	bodySprite.region_rect = tankBodyRect
	
	sideLength = int(min(collisionShape.extents.x, collisionShape.extents.y)) * 2


func _unhandled_input(event: InputEvent) -> void:
	if _isAIActive:
		return
	
	if event.is_action_pressed('fire') && ! powerIndicator.isStarted && _canFire:
		powerIndicator.start()
	elif event.is_action_released('fire') && powerIndicator.isStarted:
		var force = powerIndicator.getAndStop()
		_fire(force)


func _process(delta: float) -> void:
	if _isAIActive || _isAttacked:
		return
	
	var moveDir := Input.get_action_strength('move_forward') - Input.get_action_strength('move_back')
	if moveDir != 0:
		_moveDir = self.transform.x.normalized() * moveDir
		_acceleration = ACCELERATION
	else:
		_acceleration = DECELERATION
	
	var rotateDir := Input.get_action_strength('rotate_right') - Input.get_action_strength('rotate_left')
	_rotateDir = rotateDir


func _physics_process(delta: float) -> void:
	if _isAIActive && ! _isAttacked:
		return
	
	_speed += _acceleration * delta
	_speed = clamp(_speed, 0.0, moveSpeed)
	self.move_and_slide(_moveDir * _speed)
	self.rotation += _rotateDir * rotateSpeed * delta


func _fire(force : float) -> void:
	if ! _canFire:
		return
	
	_canFire = false
	cooldownTimer.start()
	
	animationPlayer.play('fire')
	
	var bullet = MissileScene.instance()
	bullet.init(force, missileMoveSpeed, missileMoveResistance, firePosition.global_transform.x)
	bullet.global_position = firePosition.global_position
	self.get_parent().add_child(bullet)
	
	yield(cooldownTimer, 'timeout')
	_canFire = true
	fireSprite.hide()


func _on_PowerIndicator_onMaximunReached(value) -> void:
	_fire(value)


func _on_AttackedCooldownTimer_timeout() -> void:
	_speed = 0.0
	_isAttacked = false


func _die() -> void:
	isDead = true
	self.emit_signal('dead')
	self.queue_free()


func _updateHealth() -> void:
	healthBar.updateHealth(health)


func damaged(damage : int = 1, force : Vector2 = Vector2.ZERO) -> void:
	if self.name == 'TankPlayer':
		prints('damge', damage)
	
	_isAttacked = true
	health -= damage
	if health <= 0:
		health = 0
		_die()
	else:
		force += _moveDir * _speed * 0.01
		_moveDir = force.normalized()
		_speed = force.length()
		_acceleration = DECELERATION
		attackedTimer.start()
	_updateHealth()


func setupAI(isAI : bool = false) -> void:
	_isAIActive = isAI


func fire(force : float = 1.0) -> void:
	_canFire = true
	_fire(force)



