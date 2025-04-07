extends Node


var world : Node
var player : Node2D
var camera : Node2D
var score: Node2D
var ui: Node
var level: Node = null
var sfx: Node

##
var is_touch = false

enum ContinueStates {
	INVALID,
	INIT,
	START_CONTINUE,
	INSTRUCTIONS_CONTINUE,
	IN_GAME,
	LEVEL_CONTINUE,
	GAME_CONTINUE,
	RES3
}

var state_continue : ContinueStates = ContinueStates.INIT

var flag_continue = false

var flag_reset = false

var current_level = 0

var current_hand_type : HandType = HandType.DEFAULT

var levels = [ 
	preload("res://scenes/levels/level_lipstick.tscn"),			# Lippenstift auf Damenhandtasche
	preload("res://scenes/levels/level_jeans_key.tscn"),			# Goldener Schlüssel aus Jeans
	preload("res://scenes/levels/level_fannypack_ticket.tscn"),	# Ticket Bauchtasche
	preload("res://scenes/levels/level_glass_misc.tscn"),			# Glass mit Zeug
	preload("res://scenes/levels/level_backpack_pens.tscn"),		# Stift aus Rucksack
	preload("res://scenes/levels/level_pills.tscn"),				# Pillen fürs Herz
	preload("res://scenes/levels/level_bag_nuts.tscn"),			# Walnuss aus Papiertasche
	preload("res://scenes/levels/level_glass_coin.tscn"),			# 2 EUR aus Glas
	preload("res://scenes/levels/level_cig_fannypack.tscn"),		# Zigarette aus Bauchtasche
	preload("res://scenes/levels/level_tools_wrench.tscn"),		# Maulschlüssel aus Toolbox
	preload("res://scenes/levels/level_backpack_bandaid.tscn"), 	# Rucksack Pflaster
	preload("res://scenes/levels/level_bag_screws.tscn"),			# Schrauben aus paper bag
	preload("res://scenes/levels/level_jellybeans.tscn")			# Jellybeans aus Jeans
	]
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

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
	
	sfx = get_node("/root/root/SFX")
	if !sfx:
		print("setup_nodes(): sfx node not found")

enum HandType
{
	DEFAULT,
	BURLY,
	LADY,
	DARK_LADY,
	DARK_GUY
}

# mega ugly
func setup_hand_assembly(type: HandType):
	var ha = player.get_parent()
	
	if ha != null:
		ha.queue_free()
	
	var root = get_node("/root/root/")
	
	
	var new_ha = preload("res://scenes/hand_assembly_default.tscn").instantiate()
	
	if type == HandType.DEFAULT:
		pass
	elif type == HandType.BURLY:
		new_ha = preload("res://scenes/hand_assembly_burly.tscn").instantiate()
	elif type == HandType.LADY:
		new_ha = preload("res://scenes/hand_assembly_lady.tscn").instantiate()
	elif type == HandType.DARK_LADY:
		new_ha = preload("res://scenes/hand_assembly_dark_lady.tscn").instantiate()
	elif type == HandType.DARK_GUY:
		new_ha = preload("res://scenes/hand_assembly_dark_guy.tscn").instantiate()
	
	root.add_child(new_ha)
		
	self.player = new_ha.get_node("Player")

func reset_stage():
	# clean world
	for child in world.get_children():
		child.queue_free()
	level = null
	
	print("loading level ", current_level)
	var newlevel = levels[current_level].instantiate()
	
	#print(newlevel.levelinfo.prompt)
	
	world.add_child(newlevel)
	newlevel.init()
	
	#
	level = newlevel

	score.init_level()
	
	## ugly: level sounds to sfx.level
	var rzr : AudioStreamRandomizer = sfx.get_node("level").stream #AudioStreamRandomizer
	
	while rzr.streams_count > 0:
		rzr.remove_stream(0)
	
	for stream in level.levelinfo.sounds:
		rzr.add_stream(-1, stream)
	
	setup_hand_assembly(level.levelinfo.hand_type)
	
	player.reset()
	score.reset_stage()
	
	# ui
	ui.show_level_win(false)
	
	
	
	
	
func reset():
	get_node("/root/root/World").modulate = Color.WHITE
	
	current_level = 0
	
	score.reset()
	
	reset_stage()
	
	state_game_start()

func state_game_start():
	# show level start screen
	flag_continue = false
	state_continue = ContinueStates.START_CONTINUE
	get_tree().paused = true
	
	world.visible = false
	ui.show_game_start(true)
	ui.show_instructions(false)
	ui.show_game_ui(false)
	
	# once
	ui.show_level_win(false)
	ui.show_game_win(false)
	
func state_game_howto():
	# hide  level start screen
	flag_continue = false
	state_continue = ContinueStates.INSTRUCTIONS_CONTINUE
	
	ui.show_game_start(false)
	ui.show_instructions(true)
	ui.show_game_ui(false)

func state_game_go():


	world.visible = true
	ui.show_game_start(false)
	ui.show_instructions(false)
	ui.show_game_ui(true)
	
	score.reset_stage()
	
	get_tree().paused = false

func win_level():
	flag_continue = false
	state_continue = ContinueStates.LEVEL_CONTINUE
	
	score.score_level_done() # save level score to game score
	
	ui.show_level_win(true)
	
	ui.show_game_ui(false)
	
	get_node("/root/root/World").modulate = Color.DIM_GRAY
	
	get_tree().paused = true


func state_game_next_level():
	ui.show_level_win(false)
	
	ui.show_game_ui(true)
	
	get_node("/root/root/World").modulate = Color.WHITE

	get_tree().paused = false
	

	next_level()
	reset_stage()
	
func state_game_win_game():
	ui.show_level_win(false)
	ui.show_game_win(true)
	
	world.visible = false
	ui.show_game_ui(false)
	
	flag_continue = false
	state_continue = ContinueStates.GAME_CONTINUE
	
	

func next_level():
	current_level += 1
	
	if current_level >= levels.size():
		# game done!
		current_level = levels.size()-1

func skip_level():
	next_level()
	reset_stage()	
	

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


var crunch_sfx_cooldown=0


func _physics_process(delta: float) -> void:
	
	if crunch_sfx_cooldown > 0:
		crunch_sfx_cooldown -= delta
	else:
		crunch_sfx_cooldown = 0
	
	# reset 
	if flag_reset:
		flag_reset = false
		Global.reset()
		return
	
	# continue pressed
	if flag_continue:
		flag_continue = false
		
		if state_continue == ContinueStates.START_CONTINUE:
			state_game_howto()
			state_continue = ContinueStates.INSTRUCTIONS_CONTINUE
		elif state_continue == ContinueStates.INSTRUCTIONS_CONTINUE:
	
			state_game_go()
			state_continue = ContinueStates.IN_GAME
			
		elif state_continue == ContinueStates.LEVEL_CONTINUE:
			
			if current_level == levels.size()-1: # win game
				state_game_win_game()
			else:
				state_game_next_level()
				state_continue = ContinueStates.IN_GAME

			
			
		elif state_continue == ContinueStates.GAME_CONTINUE:
			
			flag_reset = true
		
			state_continue = ContinueStates.INVALID
		


func trigger_crunch_sfx():
	if crunch_sfx_cooldown <= 0:
		sfx.get_node("level").play()
		
		crunch_sfx_cooldown = 0.4+Global.rand_norm()*0.3
	
	
