class_name Level
extends Node2D

var level: int
var sandbox: bool

var held_bird: Bird_instance # bird the player is dragging
var holding_offset: Vector2 # bird position - mouse position
var all_birds: Array[Bird_instance] # all birds being used

var birds_found: Array[Array] # array of [formula, bird found]: [Bird, Simple_bird]


func _ready() -> void:
	level = Player_data.get_instance().playing_level
	held_bird = null
	holding_offset = Vector2(0, 0)
	all_birds = []
	birds_found = []
	
	if level == 0:
		setup_sandbox()
	else:
		setup_level()


func setup_sandbox() -> void:
	var level_birds: Array[Simple_bird] = Bird_list.all_birds
	
	$Goal.bird = null
	$Goal.visible = false
	$Options/V_Center/Star.visible = false
	$Options/Done.visible = false
	
	for i in len(level_birds):
		var bird: Simple_bird = level_birds[i]
		if Player_data.get_instance().is_known(bird):
			var bird_instance: Bird_instance = Bird_list.get_bird_instance(bird)
			$Available_birds.add_bird(bird_instance)
			bird_instance.queue_free()


func setup_level() -> void:
	var level_birds: Array[Simple_bird] = Level_loader.get_level_birds(level)
	
	var goal: Simple_bird = level_birds.pop_back()
	$Goal.set_bird(goal)
	
	set_star_text()
	
	for i in len(level_birds):
		var bird: Simple_bird = level_birds[i]
		var bird_instance: Bird_instance = Bird_list.get_bird_instance(bird)
		$Available_birds.add_bird(bird_instance)
		bird_instance.queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if $Analyzer.visible and not $Analyzer.is_mouse_over and \
			event.is_action("exit_interface") and event.pressed:
		# if the player clicks off the analyzer, hide it
		$Analyzer.visible = false
		return
	
	elif event.is_action("left_click"):
		if event.pressed:
			# try to pick up a bird
			for bird in all_birds:
				if bird.is_mouse_over:
					pick_up_bird(bird)
					return
			
			if not held_bird:
				# deselect the selected bird
				select_bird_instance(null)
		else:
			drop_bird()
			return
		
	elif event.is_action("right_click") and event.pressed:
		# try to duplicate a bird
		for bird in all_birds:
			if bird.is_mouse_over:
				duplicate_bird(bird)
				return
		
	elif event is InputEventMouseMotion and held_bird != null:
		# drag the bird
		held_bird.position = get_global_mouse_position() + holding_offset
		return


func pick_up_bird(bird: Bird_instance) -> void:
	move_forward(bird)
	held_bird = bird
	holding_offset = bird.position - get_global_mouse_position()
	select_bird_instance(bird)


func drop_bird() -> void:
	if held_bird == null:
		return
	
	if $Available_birds.hitbox.overlaps_area(held_bird.hitbox):
		all_birds.erase(held_bird)
		held_bird.queue_free()
		held_bird = null
		return
	
	# try to join it to another bird
	for bird in all_birds:
		if bird == held_bird:
			continue
		if bird.hitbox.overlaps_area(held_bird.hitbox):
			join_birds(bird, held_bird)
			held_bird = null
			return
	
	held_bird = null


func duplicate_bird(bird: Bird_instance) -> void:
	var new_bird = preload("res://Birds/bird_instance.tscn").instantiate()
	$Birds.add_child(new_bird)
	new_bird.copy_params(bird)
	new_bird.position = bird.position
	
	# move the new bird to an empty space
	var i: int = 0
	while i < len(all_birds):
		if all_birds[i].position.is_equal_approx(new_bird.position):
			new_bird.position += Vector2(30, 30)
			i = 0
			continue
		i += 1
	all_birds.push_front(new_bird)
	select_bird_instance(new_bird)


func select_bird_instance(bird_instance: Bird_instance) -> void:
	if bird_instance:
		select_bird(bird_instance.bird, bird_instance.full_bird.size)
	else:
		select_bird(null, 0)


func select_bird(bird: Bird, full_bird_size: int) -> void:
	if bird:
		$Info.set_bird(bird, full_bird_size)
		$Info.visible = true
		$Analyze.visible = true
	else:
		$Info.visible = false
		$Analyze.visible = false


func _on_analyze_pressed() -> void:
	$Analyzer.set_bird($Info.bird, $Info.full_bird_size)
	$Analyzer.visible = true


# moves a bird to the foreground
# avoids needing to keep track of z_index
func move_forward(bird: Bird_instance) -> void:
	$Birds.remove_child(bird)
	$Birds.add_child(bird)
	all_birds.erase(bird)
	all_birds.push_front(bird)
		# goes to the start of the list so that it is found first during loops
		# the time this function takes is proportional to the number of birds on the screen
		# so it should never be a problem
		# other solutions are way too unreadable for such a simple task
		# GDScript built-in data structures suck :(


# creates the new bird where bird_1 is
# it's simpler to just modify bird_1
func join_birds(bird_1: Bird_instance, bird_2: Bird_instance) -> void:
	var new_bird: Bird = Apply.new(bird_1.bird, bird_2.bird)
	var new_full_bird: Bird = Apply.new(bird_1.full_bird, bird_2.full_bird)
	bird_1.set_params(preload("res://assets/Null.png"), new_bird, new_full_bird)
	all_birds.erase(bird_2)
	bird_2.queue_free()
	bird_1.simplify_completely(birds_found)
	bird_1.set_goal_effect($Goal.bird)
	select_bird_instance(bird_1)
	$Available_birds.add_bird(bird_1)


func _on_analyzer_bird_found(formula: Bird, bird: Simple_bird, full_bird_size: int) -> void:
	if not bird:
		return
	
	# reselect bird
	select_bird(bird, full_bird_size)
	
	for bird_found in birds_found:
		if bird_found[0].equals(formula) and bird_found[1].equals(bird):
			# already found
			return
	
	# new discovery
	birds_found.append([formula, bird])
	# simplify everything possible
	for bird_instance in all_birds:
		bird_instance.simplify(formula, bird, birds_found)
		bird_instance.set_goal_effect($Goal.bird)
	
	# update available birds
	$Available_birds.simplify(formula, bird, birds_found)
	$Available_birds.set_goal_effect($Goal.bird)
	
	# test whether the level was completed
	if bird.equals($Goal.bird):
		won($Available_birds.get_bird_size(bird))


# player won with a bird of size `size`
func won(size: int) -> void:
	Player_data.get_instance().set_level_beaten(level)
	if size <= Level_loader.get_level_star_size(level):
		Player_data.get_instance().set_star(level)
	set_star_text()


func set_star_text() -> void:
	var star_size: String = str(Level_loader.get_level_star_size(level))
	if not Player_data.get_instance().has_beaten_level(level):
		star_size = "[hint=beat the level to find out]?[/hint]"
	var has_star: bool = Player_data.get_instance().has_star(level)
	var star_text: String = \
			" Star: Find the " + $Goal.bird.full_name + \
			" with " + star_size + " birds or less"
	if has_star:
		star_text = "[color=yellow]" + star_text + "[/color]"
	$Options/V_Center/Star.text = star_text
	$Options/Done.visible = has_star


func _on_available_birds_bird_selected(bird: Bird_instance) -> void:
	var bird_instance: Bird_instance = preload("res://Birds/bird_instance.tscn").instantiate()
	bird_instance.copy_params(bird)
	$Birds.add_child(bird_instance)
	all_birds.push_front(bird_instance)
	held_bird = bird_instance
	holding_offset = Vector2(0, 0)
	bird_instance.position = get_global_mouse_position()
	select_bird_instance(bird_instance)


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_clear_pressed() -> void:
	for bird in all_birds:
		bird.queue_free()
	all_birds = []
	select_bird(null, 0)


func _on_reset_pressed() -> void:
	get_tree().change_scene_to_file("res://Level/level.tscn")
