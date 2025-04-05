extends PhysicsBody2D

var mouse_position: Vector2
var mouse_on_player: bool = false
var mouse_drag: bool = false
var mouse_drag_start: Vector2 

var hand_hold:bool

var position_drag_start: Vector2

var hand : PhysicsBody2D


var area_bodies = []

var hold_bodies = []
var hold_joints = []

func _ready() -> void:
	hand = get_node("/root/root/Hand")
	
	get_node("DampedSpringJoint2D").stiffness = 1000.0
	get_node("DampedSpringJoint2D").damping = 100.0
	get_node("DampedSpringJoint2DTop").stiffness = 1000.0
	get_node("DampedSpringJoint2DTop").damping = 100.0
	
func _input(event: InputEvent) -> void:

	if event is InputEventMouseMotion:
		mouse_position = event.position

		
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT:
			if event.pressed: # mouse down
				if true or mouse_on_player:
					mouse_drag = true
					mouse_drag_start = event.position
					position_drag_start = self.global_position
			else:
				mouse_drag = false
		
	
func _add_joint(body, pos):
	var new_joint = DampedSpringJoint2D.new()
	new_joint.length = 2;
	new_joint.stiffness = 240.0
	new_joint.damping = 160.0
	
	var target = self
	
	target.add_child(new_joint)
	new_joint.global_position = pos
	new_joint.disable_collision = false
	
	new_joint.node_a = target.get_path()
	new_joint.node_b = body.get_path()
	
	hold_joints.append(new_joint)	
	
func _physics_process(delta: float) -> void:
	if mouse_drag:
		# brute force: just move hand there
		self.global_position = position_drag_start + (mouse_position - mouse_drag_start)
		
		## attempt 2
		#var motion : Vector2 = position_drag_start + (mouse_position - mouse_drag_start) - self.global_position
		#motion = motion.normalized() * delta * motion.length() * 10.0
		#var coll = move_and_collide(motion)
		

		
		# attempt 3
		#var mouse_on_poly = Geometry2D.is_point_in_polygon(-self.position + position_drag_start + (mouse_position - mouse_drag_start), Global.world.get_node("Polygon2D_Drag").polygon)
#
		#if true or mouse_on_poly:
			#var motion : Vector2 = position_drag_start + (mouse_position - mouse_drag_start) - self.global_position
			#motion = motion.normalized() * clampf(motion.length() * 10.0, 1.0, 10000.0)
			#
			#velocity = lerp(velocity, motion, 10.0 * delta)
			#
			#move_and_slide()
		#else: 
			#velocity = Vector2(0,0)
		
		
	
	if mouse_drag and Input.is_action_pressed("right_click"):
		if not hand_hold:
			# now holding
			hand_hold = true
			
			# copy bodies in area
			hold_bodies = area_bodies.duplicate(false)
			
			for body in hold_bodies:
				# get y-axis
				var axis = (body as Node2D).transform.basis_xform(Vector2.UP)
				
				var h = body.get_node("Sprite2D").get_rect().size.y * body.get_node("Sprite2D").scale.y
			
				_add_joint(body, body.global_position + axis * h * -0.5)
				_add_joint(body, body.global_position + axis * h * 0)
				_add_joint(body, body.global_position + axis * h * 0.5)
					
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
		
	

		#if hand_hold:
			#for body in hold_bodies:
				#body.global_position = lerp(body.global_position, hand.global_position, 10.0 * delta)
			#
	
		


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
		
		var remove_joints = []
		for joint in hold_joints:
			if joint.node_b == body.get_path():
				remove_joints.append(joint)
				
		for joint in remove_joints:
			hold_joints.erase(joint)
			joint.queue_free()
		
		hold_bodies.erase(body)
		
		area_bodies.erase(body)
