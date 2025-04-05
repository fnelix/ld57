extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setup_nodes()
	Global.reset()
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("r"):
		Global.reset()
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = not get_tree().paused
