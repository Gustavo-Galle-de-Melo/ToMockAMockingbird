extends Control


var current_content: Content


func _ready() -> void:
	var current_tutorial: String = Player_data.get_instance().reading_tutorial
	set_content(current_tutorial)


func set_content(tutorial: String) -> void:
	if current_content:
		current_content.queue_free()
	current_content = load(tutorial).instantiate()
	add_child(current_content)
	$Previous.visible = current_content.previous != ""
	$Next.visible = current_content.next != ""
	$Menu.visible = not $Next.visible


func _on_previous_pressed() -> void:
	GlobalAudio.play_page()
	set_content(current_content.previous)


func _on_next_pressed() -> void:
	GlobalAudio.play_page()
	set_content(current_content.next)


func _on_menu_pressed() -> void:
	GlobalAudio.play_page()
	get_tree().change_scene_to_file("res://menu.tscn")
