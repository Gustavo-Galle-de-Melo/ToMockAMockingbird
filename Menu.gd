extends Control


func _process(delta: float) -> void:
	$Mouse.position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if (event.is_action("left_click") or event.is_action("right_click")) and event.pressed \
		and not $CanvasLayer/Settings_menu.is_mouse_over:
		$CanvasLayer/Settings_menu.visible = false


func _on_settings_button_pressed() -> void:
	$CanvasLayer/Settings_menu.visible = true
