# class for things like x, y and z
class_name Var
extends Bird

# 0 = x, 1 = y, 2 = z, ...
var id: int

# variables that are introduced inside parenthesis
# they must not be present in the final expression
var is_fake: bool = false


func _init(id: int) -> void:
	super(true, 0, 0, self, true)
	self.id = id


func set_fake() -> void:
	is_fake = true
	size = 1


func eval() -> Eval_result:
	return Eval_result.new(self, null, string(true), string(true))


func introduce_fake_var(next_var: int) -> Eval_result:
	return Eval_result.new(self, null, string(true), string(true))


func eliminate_fake_var() -> Eval_result:
	return Eval_result.new(self, null, string(true), string(true))


func set_vars(values: Array[Bird]) -> Bird:
	return values[id]


func set_vars_string(values: Array[Bird]) -> String:
	var color: String = argument_color(id)
	var string: String = values[id].string(false)
	if not values[id].is_leaf:
		string = "(" + string + ")"
	return "[color=%s]" % color + string + "[/color]"


func contains_fake_var(var_id: int) -> bool:
	return is_fake and id == var_id


func simplify(formula: Bird, bird: Simple_bird) -> Bird:
	return self


func equals(bird: Bird) -> bool:
	return bird is Var and bird.id == id and bird.is_fake == is_fake


func string(color: bool) -> String:
	var letter: String
	
	if id < 26:
		letter = "xyzwvutsrqponmlkjihgfedcba"[id]
	else:
		# if the player somehow managed to use more than 26 variables, then use just '?' from that point on
		# these variables will only be visually the same, internally they are still different
		letter = "?"
	
	if not color:
		return letter
	elif is_fake:
		var hint: String = "This bird is imaginary, it must not be present in the final result"
		return "[color=darkred][hint=%s]" % hint + letter + "[/hint][/color]"
	else:
		return "[color=peach_puff]" + letter + "[/color]"


func rule_string() -> String:
	return string(true)


static func argument_color(id: int) -> String:
	var colors: Array[String] = ["yellow", "orange", "orangered", "red"]
	return colors[id % len(colors)]
