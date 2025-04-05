extends Node2D

@export var levelinfo : ResourceLevelInfo


func _ready() -> void:
	pass
	
func init():
	$Limit_out.visible = false
	$Limit_win.visible = false
	
	Global.score.set_limit_out($Limit_out.global_position.y)
	Global.score.set_limit_out($Limit_win.global_position.y)
