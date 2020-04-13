extends Node2D
class_name StateController


signal getWayPoints(stateController)


export(Resource) var enemyStatus = null     # EnemyStatus
export(Resource) var currentState = null    # State
export(Resource) var remainState = null     # State
export(int, 1, 100) var maxTargetPositionRecords = 8
export(float, 0.0, 100.0) var minDistanceRecordDelta = 1.0
export var debug := false

onready var _parent := self.get_parent() as KinematicBody2D
onready var _raycastPlayer = $RayCastPlayer as RayCast2D
onready var _raycastStatic = $RayCastStatic as RayCast2D
onready var _tracerTimer = $TracerTimer as Timer
onready var _raycastLength = _raycastStatic.cast_to.length()

var chaseTarget : Node2D = null
var chaseTargetPositions := []

var nextPointIndex := 0
var wayPointsList := []

var _isAIActive := true
var _isNavigationPaused := true
var _isDebugDrawing := false
var _stateTimeElapsed := 0.0
var _rotationSpeed := 0.0

var _drawFrom := Vector2.ZERO
var _drawTo := Vector2.ZERO
var _drawColor := Color.white
var _drawSize := 0.0
var _drawRayPoint := Vector2.ZERO


func _ready() -> void:
	_parent.setupAI(true)
	_raycastPlayer.add_exception(_parent)
	_raycastStatic.add_exception(_parent)
	self.emit_signal('getWayPoints', self)
	
	print('Make sure the [getWayPoints] signal of your controller is correctly connected!')


func _process(delta: float) -> void:
	if ! _isAIActive:
		return
	
	$DebugLabel.text = currentState.resourceName if currentState != null else 'null'


func _physics_process(delta: float) -> void:
	if ! _isAIActive || currentState == null:
		return
	
	currentState.updateState(self)
	if ! _isNavigationPaused && chaseTarget != null && is_instance_valid(chaseTarget):
		_chaseTarget(delta)
	
	_parent.rotation += _rotationSpeed * delta


func _chaseTarget(delta : float) -> void:
	var dir = chaseTarget.global_position - _parent.global_position
	var angle = dir.angle()
	if abs(_parent.rotation - angle) > PI:
		_parent.rotation += 2 * PI * sign(angle)
		
	_parent.rotation = lerp(_parent.rotation, angle, 2.0 * delta)
	
	if dir.length() <= enemyStatus.attackRange:
		return
	
	_raycastPlayer.cast_to = _parent.transform.basis_xform_inv(dir)
	_raycastPlayer.force_raycast_update()
	if _raycastPlayer.is_colliding() && _raycastPlayer.get_collider() != chaseTarget:
		if debug:
			print('Colliding: %s, target: %s=%s' % [_raycastPlayer.is_colliding(), _raycastPlayer.get_collider(), chaseTarget])
		for point in chaseTargetPositions:
			_drawRayPoint = point
			var newDir = point - _parent.global_position
			_raycastStatic.cast_to = _parent.transform.basis_xform_inv(newDir)
			_raycastStatic.force_raycast_update()
			if ! _raycastStatic.is_colliding():
				dir = newDir
				break
	
	_parent.move_and_slide(enemyStatus.moveSpeed * dir.normalized())


func _on_TracerTimer_timeout() -> void:
	if ! _isNavigationPaused && chaseTarget != null && is_instance_valid(chaseTarget):
		if ! chaseTargetPositions.empty():
			var distance = chaseTarget.global_position.distance_to(chaseTargetPositions[0])
			if distance <= minDistanceRecordDelta:
				return
		if chaseTargetPositions.size() >= maxTargetPositionRecords:
			chaseTargetPositions.pop_back()
		chaseTargetPositions.push_front(chaseTarget.global_position)
		
		self.update()


func _draw() -> void:
	if ! _isAIActive:
		return
	
	if _drawSize > 0.0 && currentState != null:
		self.draw_line(_drawFrom, _drawTo, _drawColor, _drawSize)
	
	if debug:
		var i := 0
		var color := _drawColor
		for point in chaseTargetPositions:
			i += 1
			match i:
				1:
					color = Color.greenyellow
				2:
					color = Color.blueviolet
				3:
					color = Color.cyan
			self.draw_circle(self.to_local(point), _drawSize * 2.0, color)
			self.draw_circle(self.to_local(_drawRayPoint), _drawSize * 4.0, Color.black)


func _onExitState() -> void:
	_stateTimeElapsed = 0.0
	_rotationSpeed = 0.0


func setupAI(active : bool) -> void:
	_isAIActive = active


func transitionToState(nextState : Resource) -> void:
	if nextState != remainState:
		assert(nextState != null, 'The new state cannot be null!')
		currentState = nextState
		_onExitState()


func hasChaseTarget() -> bool:
	if chaseTarget == null || ! is_instance_valid(chaseTarget):
		return false
	if 'isDead' in chaseTarget:
		return ! chaseTarget.isDead
	return true


func pauseNavigation(isPaused : bool = true) -> void:
	if isPaused:
		_tracerTimer.stop()
	elif _isNavigationPaused:
		_tracerTimer.start()
	
	_isNavigationPaused = isPaused


func setTurnSpeed(speed : float) -> void:
	_rotationSpeed = speed


func checkIfCountDownElapsed(duration : float) -> bool:
	_stateTimeElapsed += self.get_physics_process_delta_time()
	if _stateTimeElapsed >= duration:
		_stateTimeElapsed = 0.0
		return true
	else:
		return false


func drawLine(from : Vector2, to : Vector2, color : Color, size : float = 2.0) -> void:
	_drawFrom = self.to_local(from)
	_drawTo = self.to_local(to)
	_drawColor = color
	_drawSize = size
	self.update()


func fire(force : float = 1.0) -> void:
	_parent.fire(force)


func moveToPoint(index : int, speed : int) -> bool:
	if wayPointsList.empty():
		return false
	
	var targetPos = wayPointsList[index]
	if _parent.global_position.distance_to(targetPos) < speed * self.get_physics_process_delta_time():
		return true
	
	var dir = (targetPos - _parent.global_position).normalized()
#	var cantMove = _parent.test_move(_parent.transform, speed * dir)
#	if cantMove:
#		dir = dir.rotated(PI / 3) # aribitary rotation
	
	var angle = dir.angle()
	if abs(_parent.rotation - angle) > PI:
		_parent.rotation += 2 * PI * sign(angle)
	
	_parent.rotation = lerp(_parent.rotation, angle, 2.0 * self.get_physics_process_delta_time())
	_parent.move_and_slide(speed * dir)
	return false








