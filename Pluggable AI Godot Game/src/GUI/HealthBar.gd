extends Node2D


onready var _progressBar := $TextureProgress as TextureProgress
onready var _tween := $Tween as Tween

var _health := 0


func _process(delta: float) -> void:
	self.global_rotation = 0.0
	
	if _progressBar.value < _progressBar.max_value * 0.25:
		_progressBar.tint_progress = Color.red
	elif _progressBar.value < _progressBar.max_value * 0.5:
		_progressBar.tint_progress = Color.orange
	else:
		_progressBar.tint_progress = Color.green
	
	
func updateHealth(value : int) -> void:
	_health = clamp(value, 0, 100)
	_tween.interpolate_property(_progressBar, 'value', _progressBar.value, _health, 1.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()

