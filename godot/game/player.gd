extends CharacterBody2D

var mouse_position: Vector2
var mouse_on_player: bool = false
var mouse_drag: bool = false
var mouse_drag_start: Vector2 

var hand_hold:bool

var position_drag_start: Vector2

var hand : RigidBody2D


var area_bodies = []

var hold_bodies = []
var hold_joints = []

func _ready() -> void:
	hand = get_node("/root/root/Hand")
	
func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		mouse_position = event.position

		
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT:
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
		
		## attempt 2
		#var motion : Vector2 = position_drag_start + (mouse_position - mouse_drag_start) - self.global_position
		#motion = motion.normalized() * delta * motion.length() * 10.0
		#var coll = move_and_collide(motion)
		

		
		# attempt 3
		var mouse_on_bag = Geometry2D.is_point_in_polygon(position_drag_start + (mouse_position - mouse_drag_start), Global.world.get_node("Bag/Polygon2D").polygon)

		if not mouse_on_bag:
			var motion : Vector2 = position_drag_start + (mouse_position - mouse_drag_start) - self.global_position
			motion = motion.normalized() * clampf(motion.length() * 10.0, 1.0, 10000.0)
			
			velocity = lerp(velocity, motion, 10.0 * delta)
			
			move_and_slide()
		else: 
			velocity = Vector2(0,0)
		
		
	
	if mouse_drag and Input.is_action_pressed("right_click"):
		if not hand_hold:
			# now holding
			hand_hold = true
			
			# copy bodies in area
			hold_bodies = area_bodies.duplicate(false)
			
			for body in hold_bodies:
				var new_joint = DampedSpringJoint2D.new()
				new_joint.length = 2;
				new_joint.stiffness = 24.0
				new_joint.damping = 16.0
				
				self.add_child(new_joint)
				new_joint.global_position = body.global_position
				new_joint.disable_collision = false
				
				new_joint.node_a = self.get_path()
				new_joint.node_b = body.get_path()
				
				hold_joints.append(new_joint)
					
			hand.get_node("Sprite2D").texture = preload("res://assets/sprites/hand/hand_closed.png")
	else:
		if hand_hold:
			# now releasing
			hand_hold = false
			
			for joint in hold_joints:
				joint.queue_free()
			
			hold_joints.clear()
			hold_bodies.clear()
			
			hand.get_node("Sprite2D").texture = preload("res://assets/sprites/hand/hand_open.png")
		
	

			
			
	
		


func _on_mouse_entered() -> void:
	mouse_on_player = true


func _on_mouse_exited() -> void:
	mouse_on_player = false




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_meta("type"):
		if not area_bodies.has(body):
			area_bodies.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.has_meta("type"):
		area_bodies.erase(body)
