extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setup_nodes()
	Global.reset()
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("r"):
		Global.reset_stage()
		
	if Input.is_action_just_pressed("x"):
		Global.reset()
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused

	if Input.is_action_just_pressed("next_level"):
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
