# class for unmodified birds like Bluebird and Cardinal
# (by modified bird I mean composite birds like ((B C) C))
class_name Simple_bird
extends Bird

var full_name: String
var symbol: String
var args: int # how many arguments thins bird needs
var formula: Bird


func _init(full_name: String, symbol: String, args: int, formula: Bird) -> void:
	super(true, 1, 0, self)
	self.full_name = full_name
	self.symbol = symbol
	self.args = args
	self.formula = formula


func eval() -> Eval_result:
	return Eval_result.new(self, null, string(true), string(true))


func set_vars(values: Array[Bird]) -> Bird:
	return self


func set_vars_string(values: Array[Bird]) -> String:
	return string(true)


func simplify(formula: Bird, bird: Simple_bird) -> Bird:
	return self


func equals(bird: Bird) -> bool:
	return bird is Simple_bird and bird.args == args and bird.formula.equals(formula)


func string(color: bool) -> String:
	return symbol


func rule_string() -> String:
	var expr: Bird = self
	for i in args:
		expr = Apply.new(expr, Var.new(i))
	var eval: Eval_result = expr.eval()
	return eval.string_before + " = " + eval.string_after
