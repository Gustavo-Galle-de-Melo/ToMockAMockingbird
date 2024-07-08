extends Control

# does not work with packedscenes, probably something to do with loops
@export_file("*.tscn") var previous: String
@export_file("*.tscn") var next: String


func _on_previous_pressed() -> void:
	get_tree().change_scene_to_file(previous)


func _on_next_pressed() -> void:
	GlobalAudio.play_page()
	get_tree().change_scene_to_file(next)
