extends Control


func _process(delta: float) -> void:
	$Mouse.position = get_global_mouse_position()
