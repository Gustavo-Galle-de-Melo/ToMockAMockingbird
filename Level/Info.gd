class_name Info
extends Control

var bird: Bird
var full_bird_size: int


func set_bird(bird: Bird, full_bird_size: int) -> void:
	self.bird = bird
	self.full_bird_size = full_bird_size
	if bird is Simple_bird:
		$Image.texture = Bird_list.get_image(bird)
		$Text.text = \
			"Name: " + bird.full_name + \
			"\nRule: " + bird.rule_string() + \
			"\nSize: " + str(full_bird_size) + " bird"
		# plural
		if full_bird_size > 1:
			$Text.text += "s"
	else:
		$Image.texture = preload("res://assets/Null.png")
		$Text.text = \
			"Name: unknown" + \
			"\nSymbol: [fade start=16]" + bird.string(true) + "[/fade]" + \
			"\nSize: " + str(full_bird_size) + " birds"
