extends RigidBody2D

var target_color = Color.WHITE
var is_carry: bool = false
var is_out: bool = false

var is_checked: bool = false

func _ready() -> void:
	set_meta("type", "object")
	self.collision_layer = pow(2,1)
	self.collision_mask = pow(2,0) + pow(2,1) + pow(2,2) + pow(2,3) + pow(2,4)
	target_color = Color.BLACK
	self.modulate = target_color
	
	self.mass = 0.1



func carry_start():
	if not is_carry:
		is_carry = true
		#self.collision_layer = pow(2,4)
	
func carry_end():
	if is_carry:
		is_carry = false
		if not is_out:
			pass
			#self.collision_layer = pow(2,1)

func touch_start():
	target_color = Color.WHITE

func touch_end():
	if not is_out:
		target_color = Color.BLACK
		
func _die():
	self.queue_free()
	
func _check_me() -> bool:
	var res = false
	
	# check win also!
	if not is_checked:
		is_checked = true
		res = Global.score.check_object(self)
		
	if res: # was winning object
		self.collision_layer = 0
		self.collision_mask = 0
		is_out = true
		
		## party
		self.gravity_scale = 0.0
		
		self.z_index = 8
		var tween = self.create_tween()
		tween.tween_property(self,"scale", Vector2(4,4), 0.5).from_current().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.set_parallel(true)
		tween.tween_property(self,"rotation", deg_to_rad(360), 0.8).from_current().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self,"modulate", Color.TRANSPARENT, 0.5).from_current().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.set_parallel(false)
		tween.tween_callback(_die)
		
		return true
	else:
		return false
		
		
var is_count_drop=false

func count_drop():
	if not is_count_drop:
		is_count_drop = true
		Global.score.count_drop()

func _physics_process(delta: float) -> void:
	
	if self.global_position.y < Global.score.limit_win:
		_check_me()
		
	if self.global_position.y < Global.score.limit_out:
		var res =  _check_me() # check object also if limit out
		
		if not res:
			
			count_drop()
			
			self.z_index = 1
			
			# out !
			Global.player._on_area_2d_body_exited(self)
			self.collision_layer = 0
			self.collision_mask = 0
			is_out = true
			
			target_color = Color.WHITE

	if self.global_position.y > 400: # y limit!!
		count_drop()
		
		self.queue_free()

	#if is_carry:
	#	self.global_position = Global.player.hand.get_node("Area2D_Grab").global_position

func _process(delta: float) -> void:
	self.modulate = lerp(self.modulate, target_color, 20.0 * delta)
