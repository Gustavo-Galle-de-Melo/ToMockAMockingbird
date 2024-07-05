extends Control

signal bird_found(formula: Bird, bird: Simple_bird, full_bird_size: int)

var full_bird_size: int
var initial_bird: Bird
var current_bird: Bird
var final_bird: Simple_bird
var next_var: int
var total_true_vars: int
var history: Array[Array] # array of [bird, next_var]: [Bird, int]
var halted: bool
var waiting: bool # waiting to show the next step

var is_mouse_over: bool = false


func set_bird(bird: Bird, full_bird_size: int) -> void:
	self.full_bird_size = full_bird_size
	initial_bird = bird
	current_bird = bird
	final_bird = null
	next_var = 0
	total_true_vars = 0
	history = []
	halted = false
	wait()


func _on_previous_pressed() -> void:
	halted = false
	
	if len(history) < 2:
		set_bird(initial_bird, full_bird_size)
		return
	
	history.pop_back()
	var state = history.pop_back()
	current_bird = state[0]
	next_var = state[1]
	waiting = true
	_on_next_pressed()


func _on_next_pressed() -> void:
	if halted:
		return
	
	if not waiting:
		wait()
		return
	waiting = false
	
	if current_bird is Simple_bird and next_var == 0:
		# bird found
		final_bird = Bird_list.get_bird_from_symbol(current_bird.string(false))
		$Before.text = current_bird.string(true)
		$After.text = current_bird.string(true)
		$Rule.text = "This is a " + final_bird.full_name if final_bird else "Unknown bird"
		history.append([current_bird, next_var])
		halted = true
		found_bird()
		return
	
	var eval: Eval_result = current_bird.eval()
	
	if eval.rule:
		# normal step
		$Before.text = eval.string_before
		$After.text = eval.string_after
		$Rule.text = eval.rule.rule_string()
		history.append([current_bird, next_var])
		current_bird = eval.new_bird
		return
		
	elif current_bird.leftmost_leaf is Var:
		# bird halted
		
		# try to introduce fake variables
		var introduction: Eval_result = current_bird.introduce_fake_var(next_var)
		
		if introduction.rule:
			$Before.text = introduction.string_before
			$After.text = introduction.string_after
			$Rule.text = "[hint=This variable must be eliminated later]More birds*[/hint]"
			history.append([current_bird, next_var])
			current_bird = introduction.new_bird
			next_var += 1
			return
		
		# try to eliminate fake variables
		var elimination: Eval_result = current_bird.eliminate_fake_var()
		if not elimination:
			$Before.text = current_bird.string(true)
			$After.text = current_bird.string(true)
			$Rule.text = "[hint=The imaginary birds could not be removed]Invalid bird[/hint]"
			history.append([current_bird, next_var])
			halted = true
			return
		elif elimination.rule:
			$Before.text = elimination.string_before
			$After.text = elimination.string_after
			$Rule.text = "Imaginary bird eliminated"
			history.append([current_bird, next_var])
			current_bird = elimination.new_bird
			return
		
		final_bird = Bird_list.get_bird_from_expression(current_bird, total_true_vars)
		history.append([current_bird, next_var])
		halted = true
		
		if final_bird and Player_data.get_instance().is_known(final_bird):
			# backward evaluation
			var expr: Bird = final_bird
			for i in total_true_vars:
				expr = Apply.new(expr, Var.new(i))
			var backward_eval: Eval_result = expr.eval()
			$Before.text = backward_eval.string_after
			$After.text = backward_eval.string_before
			$Rule.text = "This is a " + final_bird.full_name + "!"
			found_bird()
			return
		else:
			$Before.text = current_bird.string(true)
			$After.text = current_bird.string(true)
			$Rule.text = "Unknown bird"
			return
		
	else:
		# more arguments are needed
		var new_var: Var = Var.new(next_var)
		var bird_string: String = current_bird.string(true)
		$Before.text = bird_string
		if Settings.full_string and not current_bird.is_leaf:
			bird_string = Apply.colored_open + bird_string + Apply.colored_close
		$After.text = bird_string + " [color=blue]" + new_var.string(false) + "[/color]"
		$Rule.text = "More birds"
		history.append([current_bird, next_var])
		current_bird = Apply.new(current_bird, new_var)
		next_var += 1
		total_true_vars = next_var
		return


func wait() -> void:
	$Before.text = current_bird.string(true)
	$After.text = ""
	$Rule.text = ""
	waiting = true


func found_bird() -> void:
	bird_found.emit(initial_bird, final_bird, full_bird_size)


func _on_mouse_entered() -> void:
	is_mouse_over = true


func _on_mouse_exited() -> void:
	is_mouse_over = false
