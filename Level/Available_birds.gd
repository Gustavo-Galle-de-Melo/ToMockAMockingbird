class_name Available_birds
extends Control

signal bird_selected(bird_instance: Bird_instance)

var buttons: Array[Bird_button]

var is_mouse_over: bool = false
@onready var hitbox: Area2D = $Hitbox


func add_bird(bird_instance: Bird_instance) -> void:
	for button in buttons:
		if button.bird_instance.bird.equals(bird_instance.bird):
			# test whether the new bird is better than the previous one
			if button.bird_instance.full_bird.size > bird_instance.full_bird.size:
				button.set_bird(bird_instance)
			return
	
	# if this bird is not already in the list
	add_new_bird(bird_instance)


func add_new_bird(bird_instance: Bird_instance) -> void:
	var bird_button: Bird_button = preload("res://Level/bird_button.tscn").instantiate()
	bird_button.set_bird(bird_instance)
	buttons.append(bird_button)
	$ScrollContainer/Grid.add_child(bird_button)


func _input(event: InputEvent) -> void:
	if event.is_action("left_click") and event.pressed:
		for button in buttons:
			if button.bird_instance.is_mouse_over:
				bird_selected.emit(button.bird_instance)
				return


func simplify(formula: Bird, bird: Simple_bird, simplifying_rules: Array[Array]) -> void:
	for button in buttons:
		button.bird_instance.simplify(formula, bird, simplifying_rules)
	reorder()


func set_goal_effect(goal: Bird) -> void:
	for button in buttons:
		button.bird_instance.set_goal_effect(goal)


# reorders the buttons removing duplicates
func reorder() -> void:
	var simple_birds: Array[Bird_button] = []
	var composite_birds: Array[Bird_button] = []
	
	# remove and classify all birds
	for button in buttons:
		$ScrollContainer/Grid.remove_child(button)
		if button.bird_instance.bird is Simple_bird:
			append_smallest(simple_birds, button)
		else:
			append_smallest(composite_birds, button)
	
	# reintroduce all birds in the correct place
	buttons = simple_birds + composite_birds
	for button in buttons:
		$ScrollContainer/Grid.add_child(button)


# appends a button to the list
# if the bird is already in the list, only the smallest one is kept
# if a button is not in the resulting list, it is freed
func append_smallest(list: Array[Bird_button], new_button: Bird_button) -> void:
	for i in len(list):
		if list[i].bird_instance.bird.equals(new_button.bird_instance.bird):
			if list[i].bird_instance.full_bird.size <= new_button.bird_instance.full_bird.size:
				# old one is smaller
				new_button.queue_free()
			else:
				# new one is smaller
				list[i].queue_free()
				list[i] = new_button
			return
	
	# it's a new bird
	list.append(new_button)


# returns -1 if it wasn't found
func get_bird_size(bird: Bird) -> int:
	for button in buttons:
		if button.bird_instance.bird.equals(bird):
			return button.bird_instance.full_bird.size
	return -1


func _on_mouse_entered() -> void:
	is_mouse_over = true


func _on_mouse_exited() -> void:
	is_mouse_over = false
