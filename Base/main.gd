## Main.gd - Script on root node
extends Node2D

enum GameStates {LAUNCH, MENU, GAME, EXIT}
var game_state : GameStates = GameStates.LAUNCH
var test_count : int = 0


func _process(_delta: float) -> void:
	_game_cycle()
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		Input.set_custom_mouse_cursor(load("uid://chlptxeakol3y"),Input.CURSOR_ARROW)
	if event.is_action_released("LMB"):
		Input.set_custom_mouse_cursor(load("uid://b3q17ehh6rx0p"),Input.CURSOR_ARROW)

func _ready() -> void:
	Input.set_custom_mouse_cursor(load("uid://b3q17ehh6rx0p"),Input.CURSOR_ARROW)
	Interface.register_player(Interface.AudioPlayerType.SFX, %SFXPlayer)
	Interface.register_player(Interface.AudioPlayerType.MUSIC, %MusicPlayer)


func _game_cycle():
	match game_state:
		GameStates.LAUNCH:
				pass
		GameStates.EXIT:
			get_tree().quit()
	pass
