## Main.gd - Script on root node
extends Node2D

enum GameStates {LAUNCH, MENU, GAME, EXIT}
var game_state : GameStates = GameStates.LAUNCH
var test_count : int = 0


func _process(delta: float) -> void:
	_game_cycle()

func _ready() -> void:
	TranslationServer.set_locale("en")
	Interface.register_player(Interface.AudioPlayerType.SFX, %SFXPlayer)
	Interface.register_player(Interface.AudioPlayerType.MUSIC, %MusicPlayer)


func _game_cycle():
	match game_state:
		GameStates.LAUNCH:
				pass
		GameStates.EXIT:
			get_tree().quit()
	pass
