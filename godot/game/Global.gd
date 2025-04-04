extends Node


var world : Node
var player : Node3D
var camera : Node3D

##
var is_touch = false

func setup_nodes():
	
	world = get_node("/root/root/World")
	if !world:
		print("setup_nodes(): world node not found")
		
	player = get_node("/root/root/Player")
	if !player:
		print("setup_nodes(): player node not found")
		
	camera = get_node("/root/root/Camera3D")
	if !camera:
		print("setup_nodes(): camera node not found")
		

func _process(_delta):
	pass

	

# helper: align basis y to new_y
func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform


#var text_scene = preload("res://scenes/Label3D.tscn")
#
#func add_text_at(text, pos: Vector3, color : Color = Color.white):
#	var txt = text_scene.instance()
#	get_parent().add_child(txt)
#
#	pos = adjust_pos_to_screen(pos)	
#
#	txt.global_transform.origin = pos
#	txt.set_text(text)
#	txt.set_color(color)
#	txt.go()
	

func adjust_pos_to_screen(pos : Vector3):
	
	var keep_y = pos.y

	pos.y = 0.0

	#adjust position towards world center!

	#print("before:",pos, "length:",pos.length())
	var adj = clamp(pos.length_squared()/3000.0,-0.3,0.3)
	pos -= pos * adj
	#print("adj:",pos,adj)
	
	pos.y = keep_y
	
	return pos

# check for valid instance which is not queued for deletion
func check_inst(inst:Node, check_type_meta:bool = false)->bool:
	if inst==null:
		return false
	
	if not is_instance_valid(inst):
		return false
		
	if inst.is_queued_for_deletion():
		return false
	
	if check_type_meta and ( not inst.has_meta("type") ):
		return false
	
	return true
#
#func sanitize_instances_array(array:Array):
#	if array.empty():
#		return
#
#	var invalid_objects := []
#
#	for element in array:
#		if not check_inst(element, false):
#			invalid_objects.append(element)
#
#	if not invalid_objects.empty():
#		print("sanitize_instances_array: found sth.",get_stack())
#
#	for element in invalid_objects:
#		array.erase(element)


# float from -1.0 -> 1.0
func rand_norm() -> float: 
	return (randf()-0.5)*2.0



	
	
	
