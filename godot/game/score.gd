extends Node2D

var limit_out = -270
var limit_win = -270

var level_time = 0

var level_info : ResourceLevelInfo = null

var level_items_done = []

func reset():
	level_time = 0
	

func init_level():
	var level = Global.world.get_node("Level")
	level_info = level.levelinfo
	
	# set prompt
	Global.ui.set_prompt_text(level_info.prompt)
	
	# init 
	for str in level_info.win_objects:
		level_items_done.append(false)
	

func set_limit_out(val):
	limit_out = val

func check_object(obj : Node):
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
						found_one = true
						break
				i+=1
			
			if found_one:
				break
			
	# all done?
	if level_items_done.count(false) == 0:
		print("you win!")
	
	print(level_items_done)
	
	
	


func _physics_process(delta: float) -> void:
	level_time += delta
