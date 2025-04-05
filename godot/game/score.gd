extends Node2D

var limit_out = -270
var limit_win = -270


func set_limit_out(val):
	limit_out = val

func check_object(obj : Node):
	print("Check object: ", obj.get_name())
