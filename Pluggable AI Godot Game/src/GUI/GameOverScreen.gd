extends Control


onready var _label := $CenterContainer/VBoxContainer/LabelResult as Label


func setMessage(msg : String = 'Game Over!') -> void:
	_label.text = msg
