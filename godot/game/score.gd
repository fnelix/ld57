extends Node2D

var limit_out = -270
var limit_win = -270

var game_time = 0
var game_drops = 0

var level_time = 0
var level_drops = 0

var level_info : ResourceLevelInfo = null

var level_items_done = []

func reset_stage():
	level_time = 0
	level_drops = 0
	
	# init items done
	if level_info != null: # crash if level not loaded
		level_items_done = []
		for str in level_info.win_objects:
			level_items_done.append(false)
	else:
		print("level info is null")
func reset():
	game_time = 0
	game_drops = 0
	
	reset_stage()
	

func init_level():
	var level = Global.level
	level_info = level.levelinfo
	
	# set prompt
	Global.ui.set_prompt_text(level_info.prompt)
	
	Global.current_hand_type = level_info.hand_type
	
	# init items done
	level_items_done = []
	for str in level_info.win_objects:
		level_items_done.append(false)
	

func set_limit_out(val):
	limit_out = val

# object below was ok, step to win
func _check_object_success(i):
	var name = level_info.win_objects[i]
	
	Global.ui.mod_prompt_text(name)
	
	Global.sfx.get_node("checkok").play()
	
	

func check_object(obj : Node):
	var result = false
	var name =  obj.get_name()
	
	var found_one=false
	for str in level_info.win_objects:
		# is winning object?
		if name.to_lower().contains(str.to_lower()):
			
			# mark first entry not already done as done
			var i=0
			while i<level_info.win_objects.size():
				if not level_items_done[i]:
					if name.to_lower().contains(level_info.win_objects[i].to_lower()):
						level_items_done[i] = true
						
						_check_object_success(i)
						
						found_one = true
						break
				i+=1
			
			if found_one:
				break
			
	# all done?
	if level_items_done.count(false) == 0:
		print("you win!")
		Global.win_level()
	
	print(level_items_done)
	
	if found_one:
		return true
	else:
		return false
	
	
func count_drop():
	level_drops += 1
	
	Global.sfx.get_node("ugh").play()

func score_level_done():
	game_time += level_time
	game_drops += level_drops

func _physics_process(delta: float) -> void:
	level_time += delta
