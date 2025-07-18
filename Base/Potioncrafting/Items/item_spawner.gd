extends Node2D

@export_file("*.tscn") var item
@onready var button: Area2D = $button

func _ready() -> void:
	button.input_event.connect(spawn)


func spawn(_viewport, event, _index):
	if event.is_action_pressed("LMB") and Interface.player.hand_status == Player.HandStatus.EMPTY:
		var new_item = load(item).instantiate()
		get_tree().current_scene.add_child(new_item)
		new_item.position = get_global_mouse_position()
		new_item.give_me_up.emit()
	pass
