extends Node2D

enum GameStates {LAUNCH, MENU, GAME, EXIT}
var game_state : GameStates = GameStates.LAUNCH
var test_count : int = 0
func _process(delta: float) -> void:
	_game_cycle()

#func _ready() -> void:
	#var timer = get_tree().create_timer(5)
	#timer.timeout.connect(_incriment)
func _incriment():
	
	test_count += 1
	print(test_count)
	var timer = get_tree().create_timer(5)
	timer.timeout.connect(_incriment)
func _game_cycle():
	match game_state:
		GameStates.LAUNCH:
			if test_count >= 3:
				game_state = GameStates.EXIT
				return
		GameStates.EXIT:
			get_tree().quit()
	pass
