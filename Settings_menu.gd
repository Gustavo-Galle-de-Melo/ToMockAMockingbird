extends Control

var is_mouse_over: bool = false


func _ready() -> void:
	$HBoxContainer/VBoxContainer/Full_string/CheckButton.button_pressed = Settings.full_string
	update_full_string_example()


func update_full_string_example() -> void:
	var abcd: Bird = Apply.new(Bird_list.albatross, Apply.new(Apply.new(Bird_list.bluebird, Bird_list.cardinal), Bird_list.dove))
	var example: Bird = Apply.new(Apply.new(abcd, Var.new(0)), Apply.new(Var.new(1), Var.new(2)))
	$HBoxContainer/VBoxContainer/Full_string/RichTextLabel.text = "e.g. " + example.string(true)


func _on_full_string_toggled(toggled_on: bool) -> void:
	Settings.full_string = toggled_on
	update_full_string_example()


func _on_mouse_entered() -> void:
	is_mouse_over = true


func _on_mouse_exited() -> void:
	is_mouse_over = false
