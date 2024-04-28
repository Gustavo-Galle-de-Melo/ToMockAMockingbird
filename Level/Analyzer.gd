extends Control

signal bird_found(formula: Bird, bird: Simple_bird, full_bird_size: int)

var full_bird_size: int
var initial_bird: Bird
var current_bird: Bird
var final_bird: Simple_bird
var next_var: int
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
		
	elif current_bird.leftmost_leaf is Var:
		# bird halted
		final_bird = Bird_list.get_bird_from_expression(current_bird, next_var)
		history.append([current_bird, next_var])
		halted = true
		
		if final_bird and Player_data.get_instance().is_known(final_bird):
			# backward evaluation
			var expr: Bird = final_bird
			for i in next_var:
				expr = Apply.new(expr, Var.new(i))
			var backward_eval: Eval_result = expr.eval()
			$Before.text = backward_eval.string_after
			$After.text = backward_eval.string_before
			$Rule.text = "This is a " + final_bird.full_name + "!"
			found_bird()
		else:
			$Before.text = current_bird.string(true)
			$After.text = current_bird.string(true)
			$Rule.text = "Unknown bird"
		
	else:
		# more arguments are needed
		var new_var: Var = Var.new(next_var)
		var bird_string: String = current_bird.string(true)
		$Before.text = bird_string
		if Settings.full_string and not current_bird.is_leaf:
			bird_string = Apply.colored_open + bird_string + Apply.colored_close
		$After.text = bird_string + " [color=cyan]" + new_var.string(false) + "[/color]"
		$Rule.text = "More birds"
		history.append([current_bird, next_var])
		current_bird = Apply.new(current_bird, new_var)
		next_var += 1


func _on_skip_pressed() -> void:
	for i in 1000:
		waiting = true
		_on_next_pressed()
		if halted:
			break


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
