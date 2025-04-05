extends CharacterBody2D

func _ready() -> void:

	pass

func _physics_process(delta: float) -> void:
	
	var dir = Global.player.global_position - self.global_position
	var motion = dir * 10.0
	
	if dir.length() > 0.001:
		velocity = motion
		move_and_slide()
	else:
		velocity = Vector2.ZERO
	
	#self.global_position = Global.player.global_position
	#move_and_collide(motion)
