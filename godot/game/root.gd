extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.setup_nodes()
	
	
func _physics_process(_delta):
	if Input.is_action_just_pressed("r"):
		Global.reset()
