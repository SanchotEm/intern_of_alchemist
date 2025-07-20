extends Node2D

@export_file("*.tscn") var item
const BASE_ITEM_SCENE = "res://Base/Potioncrafting/Items/base_item.tscn"
@onready var button: Area2D = $button

func _ready() -> void:
	button.input_event.connect(spawn)


func spawn(_viewport, event, _index):
	if event.is_action_pressed("LMB") and Interface.player.hand_status == Player.HandStatus.EMPTY:
		var new_item :Item
		if item:
			new_item = load(item).instantiate()
		get_tree().current_scene.add_child(new_item)
		new_item.position = get_global_mouse_position()
		new_item.got_input(_viewport, event, _index)
	pass
