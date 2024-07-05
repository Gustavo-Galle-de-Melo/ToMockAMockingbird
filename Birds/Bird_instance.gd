# class for the bird scene
# this is the thing the player will drag while playing
class_name Bird_instance
extends Node2D

@export var image: Texture
var bird: Bird # simplest representation of this bird
var full_bird: Bird # how the player got here
var is_goal: bool = false

var is_mouse_over: bool = false
@onready var hitbox: Area2D = $Hitbox


func update_text() -> void:
	if not bird or not full_bird:
		$Symbol.text = "[center]?[/center]"
	elif full_bird.equals(bird):
		$Symbol.text = "[center]" + bird.string(true) + "[/center]"
	else:
		$Symbol.text = "[center][hint=%s]" % full_bird.string(false) + bird.string(true) + "[/hint][/center]"
	if is_goal:
		$Symbol.text = "[wave freq=5 amp=30][color=#ffff55]" + $Symbol.text + "[/color][/wave]"


func set_params(image: Texture, bird: Bird, full_bird: Bird) -> void:
	self.image = image
	self.bird = bird
	self.full_bird = full_bird
	$Image.texture = image
	update_text()


func copy_params(bird: Bird_instance) -> void:
	is_goal = bird.is_goal
	set_params(bird.image, bird.bird, bird.full_bird)


func _on_mouse_entered_hitbox() -> void:
	is_mouse_over = true


func _on_mouse_exited_hitbox() -> void:
	is_mouse_over = false


# returns whether something was changed
func simplify_once(formula: Bird, bird: Simple_bird) -> bool:
	
	# simplify as much as possible
	var old_bird = self.bird
	while true:
		var new_bird: Bird = self.bird.simplify(formula, bird)
		if new_bird.equals(self.bird):
			# it stopped simplifying
			break
		self.bird = new_bird
	
	# if nothing changed
	if self.bird.equals(old_bird):
		return false
	
	# if the bird was completely simplified
	if self.bird.equals(bird):
		# update image
		image = Bird_list.get_image(bird)
		$Image.texture = image
	
	update_text()
	return true


# keep simplifying untill nothing changes
func simplify_completely(simplifying_rules: Array[Array]) -> void:
	var changed: bool = false
	for simplifying_rule in simplifying_rules:
		changed = changed || simplify_once(simplifying_rule[0], simplifying_rule[1])
	if changed:
		simplify_completely(simplifying_rules)


# simplify as much as possible, but only if necessary
func simplify(formula: Bird, bird: Simple_bird, simplifying_rules: Array[Array]) -> void:
	if simplify_once(formula, bird):
		simplify_completely(simplifying_rules)


# if this bird is the goal, apply the effect to the text
func set_goal_effect(goal: Bird) -> void:
	is_goal = bird.equals(goal)
	update_text()
