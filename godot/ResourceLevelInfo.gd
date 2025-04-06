extends Resource
class_name ResourceLevelInfo

@export_multiline var prompt: String
@export var win_objects: Array[String]
@export var hand_type : Global.HandType 

@export var sounds : Array[AudioStream]

func _init(p_prompt = "", p_win_objects :Array[String]  = [], p_hand_type = Global.HandType.DEFAULT) -> void:
	prompt = p_prompt
	win_objects = p_win_objects
	hand_type = p_hand_type
