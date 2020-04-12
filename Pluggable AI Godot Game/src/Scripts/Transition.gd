"""
[Serializable]
This is a Serializable Object == Resource in Godot

Edit:
	Use [trueState] or [falseState] will lead to Cycling Dependence Error
	Change to use(load) resource File Name instead
"""
extends Resource
class_name Transition


export(Resource) var decision           # Decision
export(Resource) var trueState          # State
export(Resource) var falseState         # State

export(String, FILE, '*.tres') var trueStateResource
export(String, FILE, '*.tres') var falseStateResource

export var resouceName := 'Transition'  # Debug
