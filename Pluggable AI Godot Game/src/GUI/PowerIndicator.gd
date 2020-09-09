extends Node2D


signal onMaximunReached(value)


export var minValue := 0.25
export var maxValue := 1.0
export var duration := 1.0

onready var _tween := $Tween as Tween
onready var _progress := $ProgressBar as ProgressBar

var isStarted := false


func _ready() -> void:
	self.hide()
	

func start() -> void:
	isStarted = true
	_progress.value = minValue
	self.show()
	
	var stylebox : StyleBoxFlat = _progress.get_stylebox('fg')
	_tween.stop_all()
	_tween.interpolate_property(_progress, 'value', minValue, maxValue, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.interpolate_property(stylebox, 'bg_color', Color.green, Color.yellow, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	_tween.start()


func getAndStop() -> float:
	isStarted = false
	var value = _progress.value
	self.hide()
	_tween.stop_all()
	return value


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	_progress.value = 0.0
	isStarted = false
	self.emit_signal('onMaximunReached', maxValue)
	self.hide()
