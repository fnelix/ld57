extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setup_nodes()
	Global.reset()
	
	
func _physics_process(_delta):
	

	if Input.is_action_just_pressed("r"):
		if Global.state_continue == Global.ContinueStates.IN_GAME:
				Global.reset_stage()
	
	if Input.is_action_just_pressed("pause"):
		if Global.state_continue == Global.ContinueStates.IN_GAME:
			get_tree().paused = not get_tree().paused

	if OS.is_debug_build():
			
		if Input.is_action_just_pressed("x"):
			Global.flag_reset = true
			
		if Input.is_action_just_pressed("next_level"):
			if Global.state_continue == Global.ContinueStates.IN_GAME:
				Global.win_level()	
	



		
	
var touch_events = {}

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
			Global.is_touch  = true
			#Global.ui.touch_interface.show()
			
			var touch_count_pre = touch_events.size()
			
			if event.pressed:
				touch_events[event.index] = event
			else:
				if touch_events.has(event.index):
					touch_events.erase(event.index)
			
			var touch_count_post = touch_events.size()
			
			##
			if touch_count_pre <= 1 and touch_count_post > 1:
				Input.action_press("right_click")
			elif touch_count_pre > 1 and touch_count_post <= 1:
				Input.action_release("right_click")	
