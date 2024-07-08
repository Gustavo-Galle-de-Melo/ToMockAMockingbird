extends Control

var is_mouse_over: bool = false


func _ready() -> void:
	$VBoxContainer/Full_string/CheckButton.button_pressed = Settings.full_string
	update_full_string_example()


func update_full_string_example() -> void:
	var abcd: Bird = Apply.new(Bird_list.albatross, Apply.new(Apply.new(Bird_list.bluebird, Bird_list.cardinal), Bird_list.dove))
	var example: Bird = Apply.new(Apply.new(abcd, Var.new(0)), Apply.new(Var.new(1), Var.new(2)))
	$VBoxContainer/Full_string/RichTextLabel.text = "e.g. " + example.string(true)


func _on_full_string_toggled(toggled_on: bool) -> void:
	GlobalAudio.play_click()
	Settings.full_string = toggled_on
	update_full_string_example()


func _on_mouse_entered() -> void:
	is_mouse_over = true


func _on_mouse_exited() -> void:
	is_mouse_over = false


func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, log(value / 50) * 20)


func _on_sound_effects_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, log(value / 50) * 20)
