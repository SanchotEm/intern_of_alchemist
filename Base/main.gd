extends Node2D

enum GameStates {LAUNCH, MENU, GAME, EXIT}
var game_state : GameStates = GameStates.LAUNCH
var test_count : int = 0


func _process(delta: float) -> void:
	_game_cycle()

func _ready() -> void:
	Interface.music_player = %MusicPlayer
	Interface.sfx_player = %SFXPlayer
	Interface.narrator_player = %NarratorPlayer


func _game_cycle():
	match game_state:
		GameStates.LAUNCH:
				pass
		GameStates.EXIT:
			get_tree().quit()
	pass
