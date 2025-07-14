extends Node2D

enum GameStates {LAUNCH, MENU, GAME, EXIT}
var game_state : GameStates = GameStates.LAUNCH
var test_count : int = 0

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _process(delta: float) -> void:
	_game_cycle()

func _ready() -> void:
	var timer = get_tree().create_timer(2)
	timer.timeout.connect(_incriment)
func _incriment():
	var buses = ["Master", "SFX", "Narrator"]
	audio_stream_player.set_bus(buses[test_count])
	audio_stream_player.play()
	print(test_count)
	test_count = (test_count+1)%buses.size()
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(_incriment)
func _game_cycle():
	match game_state:
		GameStates.LAUNCH:
			#if test_count >= 3:
				#game_state = GameStates.EXIT
				#return
				pass
		GameStates.EXIT:
			get_tree().quit()
	pass
