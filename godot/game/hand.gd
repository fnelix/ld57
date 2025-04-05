extends RigidBody2D

func _ready() -> void:

	pass

func _physics_process(delta: float) -> void:
	
	var dir = Global.player.global_position - self.global_position
	var motion = dir * 10.0 * delta
	
	#self.global_position = Global.player.global_position
	move_and_collide(motion)
		#print("ok")
	#else:
		#print("not ok")
