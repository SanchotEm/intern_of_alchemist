extends Panel
func _ready() -> void:
	mouse_entered.connect(func(): Interface.player.direction = "left")
	mouse_exited.connect(func(): Interface.player.direction = "")
	print("AAA")
