class_name Tutorial_button
extends Control

var title: String
var tutorial: String
var section: int


func set_tutorial(data: Tutorial_data) -> void:
	title = data.title
	tutorial = data.scene
	section = data.section
	$Label.text = title
	if Player_data.get_instance().section < section:
		$Button.disabled = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(load(tutorial))


func _on_button_down() -> void:
	GlobalAudio.play_page()
