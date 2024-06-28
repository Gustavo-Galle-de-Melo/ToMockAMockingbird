class_name Goal
extends Control

var bird: Simple_bird


func set_bird(bird: Simple_bird) -> void:
	self.bird = bird
	$Image.texture = Bird_list.get_image(bird)
	$Name.text = "[center]" + bird.full_name + "[/center]"
	$Rule.text = "[center]" + bird.rule_string() + "[/center]"
