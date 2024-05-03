extends Control

@export var title: String
@export var tutorial: PackedScene
@export var section: int


func _ready() -> void:
	$Label.text = title
	if Player_data.get_instance().section < section:
		$Button.disabled = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(tutorial)
