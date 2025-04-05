extends RigidBody2D

var target_color = Color.WHITE
var is_carry: bool = false
var is_out: bool = false

var is_checked: bool = false

func _ready() -> void:
	set_meta("type", "object")
	self.collision_layer = pow(2,1)
	
	target_color = Color.BLACK
	$Sprite2D.modulate = target_color



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

func _physics_process(delta: float) -> void:
	
	if self.global_position.y < Global.score.limit_win:
		if not is_checked:
			is_checked = true
			Global.score.check_object(self)
		pass
		
	if self.global_position.y < Global.score.limit_out:
		# check win also!
		if not is_checked:
			is_checked = true
			Global.score.check_object(self)
		
		Global.player._on_area_2d_body_exited(self)
		self.collision_layer = 16
		self.collision_mask = 0
		is_out = true
		
		target_color = Color.WHITE

	#if is_carry:
	#	self.global_position = Global.player.hand.get_node("Area2D_Grab").global_position

func _process(delta: float) -> void:
	$Sprite2D.modulate = lerp($Sprite2D.modulate, target_color, 20.0 * delta)
