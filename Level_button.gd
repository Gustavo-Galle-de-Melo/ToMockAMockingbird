class_name Level_button
extends Control

var number: int


func set_number(number) -> void:
	self.number = number
	if number == 0:
		# sandbox
		$Number.text = "0"
		$Name.text = "Sandbox"
		$Star.visible = false
		$Button.disabled = Player_data.get_instance().section < Level_loader.get_level_section(number)
	
	else:
		# normal level
		$Number.text = str(number)
		$Name.text = Level_loader.get_level_name(number)
		var star_size: String = str(Level_loader.get_level_star_size(number))
		if Player_data.get_instance().has_beaten_level(number):
			$Star.tooltip_text = "Beat this level with " + star_size + " birds or less"
			if Player_data.get_instance().has_star(number):
				$Star.texture = preload("res://assets/fullStar.png")
			else:
				$Star.texture = preload("res://assets/emptyStar.png")
		else:
			$Star.visible = false
			$Background.texture = preload("res://assets/levelUnbeaten.png")
		$Button.disabled = Player_data.get_instance().section < Level_loader.get_level_section(number)


func _on_button_pressed() -> void:
	Player_data.get_instance().playing_level = number
	get_tree().change_scene_to_file("res://Level/level.tscn")


func _on_button_down() -> void:
	GlobalAudio.play_click()
