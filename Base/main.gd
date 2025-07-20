## Main.gd - Script on root node
extends Node2D


var test_count : int = 0




func _ready() -> void:
	
	Interface.register_player(Interface.AudioPlayerType.SFX, %SFXPlayer)
	Interface.register_player(Interface.AudioPlayerType.MUSIC, %MusicPlayer)



	pass
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB") or event.is_action_pressed("RMB"):
		Input.set_custom_mouse_cursor(load("uid://chlptxeakol3y"),Input.CURSOR_ARROW)
	elif event.is_action_released("LMB") or event.is_action_released("RMB"):
		Input.set_custom_mouse_cursor(load("uid://b3q17ehh6rx0p"),Input.CURSOR_ARROW)
