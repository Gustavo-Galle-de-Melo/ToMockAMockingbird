# abstract class for all birds
# includes Apply (e.g. (A B)), Simple_bird (e.g. Bluebird) and Var (e.g. x)
# these classes must be immutable
class_name Bird

var is_leaf: bool
var size: int
var depth: int # distance from this node to the leftmost leaf
var leftmost_leaf: Bird


func _init(is_leaf: bool, size: int, depth: int, leftmost_leaf: Bird) -> void:
	self.is_leaf = is_leaf
	self.size = size
	self.depth = depth
	self.leftmost_leaf = leftmost_leaf


# evaluates the bird
func eval() -> Eval_result:
	return null


# replace all variables in this bird by their values
func set_vars(values: Array[Bird]) -> Bird:
	return null


# same thing as set_vars(), but returns a color-coded string of the result
func set_vars_string(values: Array[Bird]) -> String:
	return ""


# find every occurrence of `formula` and replace it with `bird`
func simplify(formula: Bird, bird: Simple_bird) -> Bird:
	return null


func equals(bird: Bird) -> bool:
	return false


func string(color: bool) -> String:
	return ""


# B x y z = x (y z)
func rule_string() -> String:
	return ""
