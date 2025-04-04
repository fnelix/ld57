extends Node

func time2hhmmss(s: float) -> String:
	#total_seconds = 12345
	var seconds:float = fmod(s , 60.0)
	var minutes:int   =  int(s / 60.0) % 60
	var hours:  int   =  int(s / 3600.0)
	var str:String = "%02d:%02d:%02.0f" % [hours, minutes, seconds]
	return str

func set_prompt_text(text):
	$MarginContainer/VBoxContainer/MarginContainer/MarginContainer/LabelText.text = text

func _process(delta: float) -> void:
	$MarginContainer/VBoxContainer/Label.text = "%s " % [ time2hhmmss(Global.score.level_time)]
