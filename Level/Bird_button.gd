class_name Bird_button
extends Control

@onready var bird_instance = $Bird_instance


func set_bird(bird_instance: Bird_instance) -> void:
	$Bird_instance.copy_params(bird_instance)
