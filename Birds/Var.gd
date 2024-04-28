# class for things like x, y and z
class_name Var
extends Bird

# 0 = x, 1 = y, 2 = z, ...
var id: int


func _init(id: int) -> void:
	super(true, 0, 0, self)
	self.id = id


func eval() -> Eval_result:
	return Eval_result.new(self, null, string(true), string(true))


func set_vars(values: Array[Bird]) -> Bird:
	return values[id]


func set_vars_string(values: Array[Bird]) -> String:
	var color: String = argument_color(id)
	var string: String = values[id].string(false)
	if not values[id].is_leaf:
		string = "(" + string + ")"
	return "[color=%s]" % color + string + "[/color]"


func simplify(formula: Bird, bird: Simple_bird) -> Bird:
	return self


func equals(bird: Bird) -> bool:
	return bird is Var and bird.id == id


func string(color: bool) -> String:
	var letter: String
	
	if id < 26:
		letter = "xyzwvutsrqponmlkjihgfedcba"[id]
	else:
		# if the player somehow managed to use more than 26 variables, then use just '?' from that point on
		# these variables will only be visually the same, internally they are still different
		letter = "?"
	
	if color:
		return "[color=blanched_almond]" + letter + "[/color]"
	else:
		return letter


func rule_string() -> String:
	return string(true)


static func argument_color(id: int) -> String:
	var colors: Array[String] = ["yellow", "orange", "orangered", "red"]
	return colors[id % len(colors)]
