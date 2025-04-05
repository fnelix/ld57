extends Resource
class_name ResourceLevelInfo

@export_multiline var prompt: String
@export var win_objects: Array[String]

func _init(p_prompt = "", p_win_objects :Array[String]  = []) -> void:
	prompt = p_prompt
	win_objects = p_win_objects
