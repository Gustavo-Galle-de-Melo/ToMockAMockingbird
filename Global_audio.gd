# class for all sounds
# it was going to be a clss dedicated to the sounds that might happen during while changing scenes
# but it seems more convenient to use it for all sounds
extends Node

# TODO autoplay music

func play_click() -> void:
	$Click.play()

func play_page() -> void:
	$Page.play()

func play_win() -> void:
	$Win.play()
