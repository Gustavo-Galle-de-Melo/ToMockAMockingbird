# this class represents lambda abstractions (variable introduction inside parenthesis)
# this is only used in very rare circumstances
# example of a situation that needs this:
	# level: B C -> P
	# intended solution: P = B C C
	# another solution: C B (B C C)
	# if the player finds the intended solution, then the other solution becomes:
	# C B (B C C) = C B P
	# verifying this solution would go as follows:
		# C B P
		# C B P x
		# B x P
		# B x P y
		# x (P y)
		# x y
		# P x y	# correct solution
	# however, if the player does not find the intended solution first,
	# then C B (B C C) does not become C B P, so this would be the verification:
		# C B (B C C)
		# C B (B C C) x
		# B x (B C C)
		# B x (B C C) y
		# x (B C C y)
		# x (C (C y))	# unknown bird
	# the evaluation halts, since both verifications halted differently,
	# this is equivalent to saying that they are different birds
	# this would mean that verifying the solution changes the bird, which is bad
	# this class solves this by introducing fake variables:
		# x (C (C y) 'z')		# 'z' introduction
		# x (C (C y) 'z' 'w')	# 'w' introduction
		# x (C y 'w' 'z')
		# x (y 'z' 'w')
		# x (y 'z')				# 'w' elimination
		# x y					# 'z' elimination
		# P x y	# correct solution
class_name Lambda
extends Bird

var var_id: int
var bird: Bird



func _init(var_id: int, bird: Bird) -> void:
	super(bird.is_leaf, bird.size, bird.depth, bird.leftmost_leaf, bird.contains_var)
	self.var_id = var_id
	self.bird = bird


func eval() -> Eval_result:
	var result: Eval_result = bird.eval()
	return Eval_result.new(
		new(var_id, result.new_bird),
		result.rule,
		result.string_before,
		result.string_after
	)


func introduce_fake_var(next_var: int) -> Eval_result:
	var result = bird.introduce_fake_var(next_var)
	return Eval_result.new(
		new(var_id, result.new_bird),
		result.rule,
		result.string_before,
		result.string_after
	)


func eliminate_fake_var() -> Eval_result:
	if bird is Lambda:
		var result: Eval_result = bird.eliminate_fake_var()
		
		if not result:
			return null
		
		if result.rule:
			return Eval_result.new(
				new(var_id, result.new_bird),
				result.rule,
				result.string_before,
				result.string_after
			)
	
	if not bird is Apply:
		return null
	
	var fake_var: Var = bird.right as Var
	
	if not fake_var or not fake_var.is_fake or fake_var.id != var_id:
		return null
	
	if bird.left.contains_fake_var(var_id):
		return null
	
	return Eval_result.new(bird.left, fake_var, string(true), bird.left.string(true))

func set_vars(values: Array[Bird]) -> Bird:
	return new(var_id, bird.set_vars(values))


func set_vars_string(values: Array[Bird]) -> String:
	return bird.set_vars_string(values)


func contains_fake_var(var_id: int) -> bool:
	return bird.contains_fake_var(var_id)


func simplify(formula: Bird, bird: Simple_bird) -> Bird:
	return new(var_id, bird.simplify(formula, bird))


func equals(bird: Bird) -> bool:
	return bird is Lambda and bird.var_id == var_id and bird.bird == bird


func string(color: bool) -> String:
	return bird.string(color)


func rule_string() -> String:
	return bird.rule_string()
