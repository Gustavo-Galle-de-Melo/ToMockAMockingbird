extends Control

static var mouse_position: Vector2 = Vector2(0, 0)
var camera_movement_enabled: bool = false

func _ready() -> void:
	# set camera position
	$Mouse.position = mouse_position
	$Mouse/Camera.drag_horizontal_enabled = false
	$Mouse/Camera.reset_smoothing()
	$Mouse/Camera.drag_horizontal_enabled = true
	
	# hides a single frame that is rendered before the camera moves
	$CanvasLayer/Transition.visible = true


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
