extends Node

func time2hhmmss(s: float) -> String:
	#total_seconds = 12345
	var seconds:float = fmod(s , 60.0)
	var minutes:int   =  int(s / 60.0) % 60
	var hours:  int   =  int(s / 3600.0)
	var str:String = "%02d:%02d:%02.0f" % [hours, minutes, seconds]
	return str

func set_prompt_text(text):
	%LabelPrompt.text = text

func mod_prompt_text(name):
	var text : String = %LabelPrompt.text 
	
	text = text.replacen(name, "[s]"+name+"[/s]")
	
	%LabelPrompt.text = text
	

func _process(delta: float) -> void:
	%LabelTime.text = "%s " % [ time2hhmmss(Global.score.level_time)]

	
func show_level_win(value: bool):
	%LevelWinPanel.visible = value
	%LabelLevelText.text = "Dropped Objects: %s\nTime Penalty: %s\nTime: %s"  % [ Global.score.level_drops, time2hhmmss(Global.score.level_drops*10), time2hhmmss(Global.score.level_time) ]
	

	
func show_game_win(value: bool):

	%GameWinPanel.visible = value
	%LabelGameText.text = "Overall Score:\nDropped Objects: %s\nTime Penalty: %s\nTime: %s"  % [ Global.score.game_drops, time2hhmmss(Global.score.game_drops*10), time2hhmmss(Global.score.game_time)]

func show_game_start(value: bool):
	%GameStartPanel.visible = value
	
func show_instructions(value: bool):
	%InstructionsPanel.visible = value
	
func show_game_ui(value:bool):
	%GameUI.visible = value
	
	
func flash_timer():
	print("Blitz")
	var tween = get_tree().create_tween() 
	tween.parallel().tween_property(%LabelTime, "scale", Vector2(1,1.1), 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(%LabelTime, "modulate", Color.RED, 0.15).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(%LabelTime, "scale", Vector2(1,1), 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%LabelTime, "modulate", Color.BLACK, 0.1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	

func _on_button_continue_pressed() -> void:
	Global.flag_continue = true


func _on_button_reset_pressed() -> void:
	Input.action_press("r")
	Input.action_release("r")


func _on_button_hand_free_pressed() -> void:
	Input.action_press("f")
	Input.action_release("f")


func _on_button_start_game_pressed() -> void:
	Global.flag_continue = true


func _on_button_howto_contiue_pressed() -> void:
	Global.flag_continue = true


func _on_button_new_game_pressed() -> void:
	Global.flag_continue = true
