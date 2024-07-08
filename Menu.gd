extends Control

static var mouse_position: Vector2 = Vector2(0, 0)
var camera_movement_enabled: bool = false

var is_mouse_over_settings_button: bool = false

@export var demo: bool = false

func _ready() -> void:
	if demo:
		Player_data.get_instance().set_section(15)

	# set camera position
	$Mouse.position = mouse_position
	$Mouse/Camera.drag_horizontal_enabled = false
	$Mouse/Camera.reset_smoothing()
	$Mouse/Camera.drag_horizontal_enabled = true
	
	# hides a single frame that is rendered before the camera moves
	$CanvasLayer/Transition.visible = true
	
	var center: Vector2 = get_viewport_rect().size / 2
	
	# add level and tutorial buttons
	Level_loader.number_levels()
	for i in len(Level_loader.levels_and_tutorials):
		var level_or_tutorial = Level_loader.levels_and_tutorials[i]
		var button
		if level_or_tutorial is Level_data:
			button = preload("res://level_button.tscn").instantiate()
			button.set_number(level_or_tutorial.number)
		else:
			button = preload("res://Tutorials/tutorial_button.tscn").instantiate()
			button.set_tutorial(level_or_tutorial)
		button.position = center + Vector2(300 * (i - 2) - 125, - 150 * sin((i - 2) * PI / 4) - 125)
		$Mouse/Camera.limit_right = button.position.x + center.x + 125
		add_child(button)


func _process(delta: float) -> void:
	$CanvasLayer/Transition.visible = false
	if camera_movement_enabled:
		mouse_position = get_global_mouse_position()
	$Mouse.position = mouse_position


func _input(event: InputEvent) -> void:
	if event.is_action("exit_interface") and event.pressed \
			and not $CanvasLayer/Settings_menu.is_mouse_over \
			and not is_mouse_over_settings_button:
		$CanvasLayer/Settings_menu.visible = false


func _on_settings_button_pressed() -> void:
	$CanvasLayer/Settings_menu.visible = not $CanvasLayer/Settings_menu.visible


func _on_settings_button_down() -> void:
	GlobalAudio.play_click()


func _on_scroll_cooldown_timeout() -> void:
	camera_movement_enabled = true
	$Mouse/Camera.position_smoothing_speed = 5


func _on_settings_button_mouse_entered() -> void:
	is_mouse_over_settings_button = true


func _on_settings_button_mouse_exited() -> void:
	is_mouse_over_settings_button = false
