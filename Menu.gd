extends Control

static var mouse_position: Vector2 = Vector2(0, 0)
var camera_movement_enabled: bool = false

# TODO remove this
@export var demo: bool = false

func _ready() -> void:
	# TODO remove this
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
		add_child(button)


func _process(delta: float) -> void:
	$CanvasLayer/Transition.visible = false
	if camera_movement_enabled:
		mouse_position = get_global_mouse_position()
	$Mouse.position = mouse_position


func _input(event: InputEvent) -> void:
	if event.is_action("exit_interface") and event.pressed \
		and not $CanvasLayer/Settings_menu.is_mouse_over:
		$CanvasLayer/Settings_menu.visible = false


func _on_settings_button_pressed() -> void:
	$CanvasLayer/Settings_menu.visible = true


func _on_scroll_cooldown_timeout() -> void:
	camera_movement_enabled = true
	$Mouse/Camera.position_smoothing_speed = 5
