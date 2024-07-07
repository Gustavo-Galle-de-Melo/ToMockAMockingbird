# class for bird aplication (composite birds)
class_name Apply
extends Bird

var left: Bird
var right: Bird

const colored_open: String = "[color=gray]([/color]"	# "("
const colored_close: String = "[color=gray])[/color]"	# ")"


func _init(left: Bird, right: Bird) -> void:
	super(
		false,
		left.size + right.size,
		left.depth + 1,
		left.leftmost_leaf,
		left.contains_var or right.contains_var
	)
	self.left = left
	self.right = right


func eval() -> Eval_result:
	if leftmost_leaf is Var:
		# this expression halted
		
		var strings: Array[String] = strings(true)
		
		# try to continue evaluation on subexpressions
		var result_left: Eval_result = left.eval()
		
		if result_left.rule:
			# something was evaluated
			var new_string_before: String = result_left.string_before
			if Settings.full_string and not left.is_leaf:
				new_string_before = colored_open + new_string_before + colored_close
			
			var new_string_after: String = result_left.string_after
			if Settings.full_string and not result_left.new_bird.is_leaf:
				new_string_after = colored_open + new_string_after + colored_close
			
			return Eval_result.new(
					new(result_left.new_bird, right),
					result_left.rule,
					new_string_before + " " + strings[1],
					new_string_after + " " + strings[1]
				)
		
		# nothing was evaluated on the left, try evaluating the right
		var result_right: Eval_result = right.eval() # may or may not evaluate something
		
		var new_string_before: String = result_right.string_before
		if not right.is_leaf:
			new_string_before = colored_open + new_string_before + colored_close
		
		var new_string_after: String = result_right.string_after
		if not result_right.new_bird.is_leaf:
			new_string_after = colored_open + new_string_after + colored_close
		
		return Eval_result.new( # return it either way
				new(left, result_right.new_bird),
				result_right.rule,
				strings[0] + " " + new_string_before,
				strings[0] + " " + new_string_after
			)
		
	elif leftmost_leaf.args < depth:
		# evaluate left node
		var result: Eval_result = left.eval()
		var right_string: String = strings(true)[1]
		
		var new_string_before: String = result.string_before
		if Settings.full_string and not left.is_leaf:
			new_string_before = colored_open + new_string_before + colored_close
		
		var new_string_after: String = result.string_after
		if Settings.full_string and not result.new_bird.is_leaf:
			new_string_after = colored_open + new_string_after + colored_close
		
		return Eval_result.new(
				new(result.new_bird, right),
				result.rule,
				new_string_before + " " + right_string,
				new_string_after + " " + right_string
			)
		
	elif leftmost_leaf.args > depth:
		# this expression halted
		# more arguments are needed
		var string: String = string(true)
		return Eval_result.new(self, null, string, string)
		
	else: # leftmost_leaf.args == depth
		# a reduction can be done
		
		# list all arguments
		var args: Array[Bird] = []
		args.resize(depth)
		var sub_tree = self
		for i in range(depth - 1, -1, -1):
			var arg: Bird = sub_tree.right
			sub_tree = sub_tree.left
			args[i] = arg
		
		# replace the arguments by their value
		var new_expr: Bird = leftmost_leaf.formula.set_vars(args)
		
		# paint the before string
		var string_before: String = "[b][color=green]" + leftmost_leaf.string(false) + "[/color][/b]"
		for i in len(args):
			var color: String = Var.argument_color(i)
			var arg_string: String = args[i].string(false)
			if not args[i].is_leaf:
				arg_string = "(" + arg_string + ")"
			if Settings.full_string and i > 0:
				string_before = colored_open + string_before + colored_close
			string_before += " [color=%s]" % color + arg_string + "[/color]"
		
		var string_after: String = leftmost_leaf.formula.set_vars_string(args)
		
		return Eval_result.new(new_expr, leftmost_leaf, string_before, string_after)


func introduce_fake_var(next_var: int) -> Eval_result:
	if leftmost_leaf is Simple_bird and contains_var and size > 1:
		var new_var: Var = Var.new(next_var)
		new_var.set_fake()
		
		var new_bird: Bird = Lambda.new(next_var, new(self, new_var))
		return Eval_result.new(
			new_bird,
			new_var,
			string(true),
			new_bird.string(true)
		)
	
	else:
		var left_result: Eval_result = left.introduce_fake_var(next_var)
		if left_result.rule:
			var string_right: String = strings(true)[1]
			
			var string_left_before: String = left_result.string_before
			if Settings.full_string and not left.is_leaf:
				string_left_before = colored_open + string_left_before + colored_close
			
			var string_left_after: String = left_result.string_after
			if Settings.full_string and not left_result.new_bird.is_leaf:
				string_left_after = colored_open + string_left_after + colored_close
			
			return Eval_result.new(
				new(left_result.new_bird, right),
				left_result.rule,
				string_left_before + " " + string_right,
				string_left_after + " " + string_right
			)
		
		var right_result: Eval_result = right.introduce_fake_var(next_var)
		if right_result.rule:
			var string_left: String = strings(true)[0]
			
			var string_right_before: String = right_result.string_before
			if not right.is_leaf:
				string_right_before = colored_open + string_right_before + colored_close
			
			var string_right_after: String = right_result.string_after
			if not right_result.new_bird.is_leaf:
				string_right_after = colored_open + string_right_after + colored_close
			
			return Eval_result.new(
				new(left, right_result.new_bird),
				right_result.rule,
				string_left + " " + string_right_before,
				string_left + " " + string_right_after
			)
		
		return Eval_result.new(self, null, string(true), string(true))


func eliminate_fake_var() -> Eval_result:
	var left_result: Eval_result = left.eliminate_fake_var()
	
	if not left_result:
		return null
	
	if left_result.rule:
		var string_right: String = strings(true)[1]
		
		var string_left_before: String = left_result.string_before
		if Settings.full_string and not left.is_leaf:
			string_left_before = colored_open + string_left_before + colored_close
		
		var string_left_after: String = left_result.string_after
		if Settings.full_string and not left_result.new_bird.is_leaf:
			string_left_after = colored_open + string_left_after + colored_close
		
		return Eval_result.new(
			new(left_result.new_bird, right),
			left_result.rule,
			string_left_before + " " + string_right,
			string_left_after + " " + string_right
		)
	
	var right_result: Eval_result = right.eliminate_fake_var()
	
	if not right_result:
		return null
	
	if right_result.rule:
		var string_left: String = strings(true)[0]
		
		var string_right_before: String = right_result.string_before
		if not right.is_leaf:
			string_right_before = colored_open + string_right_before + colored_close
		
		var string_right_after: String = right_result.string_after
		if not right_result.new_bird.is_leaf:
			string_right_after = colored_open + string_right_after + colored_close
		
		return Eval_result.new(
			new(left, right_result.new_bird),
			right_result.rule,
			string_left + " " + string_right_before,
			string_left + " " + string_right_after
		)
	
	return Eval_result.new(self, null, string(true), string(true))


func set_vars(values: Array[Bird]) -> Bird:
	return new(left.set_vars(values), right.set_vars(values))


func set_vars_string(values: Array[Bird]) -> String:
	var left_string: String = left.set_vars_string(values)
	if Settings.full_string and not left.is_leaf:
		left_string = colored_open + left_string + colored_close
	
	var right_string: String = right.set_vars_string(values)
	if not right.is_leaf:
		right_string = colored_open + right_string + colored_close
	
	return left_string + " " + right_string


func contains_fake_var(var_id: int) -> bool:
	return left.contains_fake_var(var_id) or right.contains_fake_var(var_id)


func simplify(formula: Bird, bird: Simple_bird) -> Bird:
	if equals(formula):
		return bird
	return new(left.simplify(formula, bird), right.simplify(formula, bird))


func equals(bird: Bird) -> bool:
	return bird is Apply and bird.left.equals(left) and bird.right.equals(right)


func string(color: bool) -> String:
	var strings: Array[String] = strings(color)
	return strings[0] + " " + strings[1]


# [left string, right string]
func strings(color: bool) -> Array[String]:
	var open_parens: String = colored_open if color else "("
	var close_parens: String = colored_close if color else ")"
	
	var left_string: String = left.string(color)
	if Settings.full_string and not left.is_leaf:
		left_string = open_parens + left_string + close_parens
	
	var right_string: String = right.string(color)
	if not right.is_leaf:
		right_string = open_parens + right_string + close_parens
	
	return [left_string, right_string]


func rule_string() -> String:
	var left_string: String = left.rule_string()
	if Settings.full_string and not left.is_leaf:
		left_string = colored_open + left_string + colored_close
	
	var right_string: String = right.rule_string()
	if not right.is_leaf:
		right_string = colored_open + right_string + colored_close
	
	return left_string + " " + right_string
