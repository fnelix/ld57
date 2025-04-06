extends Node


var world : Node
var player : Node2D
var camera : Node2D
var score: Node2D
var ui: Node
var level: Node = null

##
var is_touch = false

enum ContinueStates {
	INVALID,
	INIT,
	RES1,
	RES2,
	LEVEL_CONTINUE,
	GAME_CONTINUE,
	RES3
}

var state_continue : ContinueStates = ContinueStates.INIT

var flag_continue = false

var current_level = 0

var levels = [ 
	preload("res://scenes/levels/level_lipstick.tscn"),
	preload("res://scenes/levels/level_jeans_key.tscn"),
	preload("res://scenes/levels/level_backpack_pens.tscn"),
	
	preload("res://scenes/levels/level_jellybeans.tscn")
	]

func setup_nodes():
	
	world = get_node("/root/root/World")
	if !world:
		print("setup_nodes(): world node not found")
		
	player = get_node("/root/root/HandAssembly/Player")
	if !player:
		print("setup_nodes(): player node not found")
		
	camera = get_node("/root/root/Camera")
	if !camera:
		print("setup_nodes(): camera node not found")
	
	score = get_node("/root/root/Score")
	if !score:
		print("setup_nodes(): score node not found")
		
	ui = get_node("/root/root/UI")
	if !ui:
		print("setup_nodes(): ui node not found")


func reset_stage():
	# clean world
	for child in world.get_children():
		child.queue_free()
	level = null
	
	print("loading level ", current_level)
	var newlevel = levels[current_level].instantiate()
	
	print(newlevel.levelinfo.prompt)
	
	world.add_child(newlevel)
	newlevel.init()
	
	#
	level = newlevel

	score.init_level()
	
	player.reset()
	score.reset()
	
	# ui
	ui.show_level_win(false)
	
	
	
	
	
func reset():
	current_level = 0
	reset_stage()

func next_level():
	current_level += 1
	
	if current_level >= levels.size():
		# game done!
		current_level = levels.size()-1

func skip_level():
	next_level()
	reset_stage()
	
	

func win_level():
	flag_continue = false
	state_continue = ContinueStates.LEVEL_CONTINUE
	ui.show_level_win(true)
	
	

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


# float from -1.0 -> 1.0
func rand_norm() -> float: 
	return (randf()-0.5)*2.0


func _physics_process(delta: float) -> void:
	
	if flag_continue:
		flag_continue = false
		
		if state_continue == ContinueStates.LEVEL_CONTINUE:
			ui.show_level_win(false)
			next_level()
			reset_stage()	
			state_continue = ContinueStates.INVALID
			
		

	
	
	
