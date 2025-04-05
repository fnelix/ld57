extends CharacterBody2D

var mouse_position: Vector2
var mouse_on_player: bool = false
var mouse_drag: bool = false
var mouse_drag_start: Vector2 

var position_drag_start: Vector2

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		mouse_position = event.position
	elif event is InputEventMouseButton:
		if event.pressed: # mouse down
			if mouse_on_player:
				mouse_drag = true
				mouse_drag_start = event.position
				position_drag_start = self.global_position
		else:
			mouse_drag = false
			
	
func _physics_process(delta: float) -> void:
	if mouse_drag:
		# brute force: just move hand there
		#self.global_position = position_drag_start + (mouse_position - mouse_drag_start)
		var motion : Vector2 = position_drag_start + (mouse_position - mouse_drag_start) - self.global_position
		motion = motion.normalized() * delta * motion.length() * 10.0
		move_and_collide(motion)
		
		
		pass
		
	


func _on_mouse_entered() -> void:
	mouse_on_player = true


func _on_mouse_exited() -> void:
	mouse_on_player = false
