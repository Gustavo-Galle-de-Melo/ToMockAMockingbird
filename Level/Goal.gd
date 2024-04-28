class_name Goal
extends Control

var bird: Simple_bird


func set_bird(bird: Simple_bird) -> void:
	self.bird = bird
	$Image.texture = Bird_list.get_image(bird)
	$Info.text = "Name: " + bird.full_name + "\nRule: " + bird.rule_string()
