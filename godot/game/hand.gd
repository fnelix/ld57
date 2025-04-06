extends RigidBody2D

func _ready() -> void:


	pass

func _physics_process(delta: float) -> void:
	
	if Global.player.mouse_drag:
		var dir = Global.player.global_position - self.global_position
		var motion = dir * 10.0 * delta
		
		if dir.length() > 0.001:
			if true or not test_move(self.transform, motion):		
				var coll = move_and_collide(motion)
				
				if coll:
					var collider = coll.get_collider()
					if collider.has_meta("type"):
						var pos = coll.get_position()
						#collider.apply_impulse(motion * 4.0, pos)
						#collider.apply_central_force(motion * 10.0)
						collider.apply_central_impulse(motion.normalized() * 20.0)
			#velocity = motion
			#move_and_slide()
		else:
			pass
			#velocity = Vector2.ZERO
		
		#self.global_position = Global.player.global_position
		#move_and_collide(motion)

	if self.global_position.x < -110:
		self.global_position.x = -110
	elif self.global_position.x > 110:
		self.global_position.x = 110

	if self.global_position.y < -500:
		self.global_position.y = -500
	elif self.global_position.y > 50:
		self.global_position.y = 50
