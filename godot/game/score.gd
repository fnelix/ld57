extends Node2D

var limit_out = -270
var limit_win = -270

var level_time = 0

func reset():
	level_time = 0

func set_limit_out(val):
	limit_out = val

func check_object(obj : Node):
	print("Check object: ", obj.get_name())


func _physics_process(delta: float) -> void:
	level_time += delta
