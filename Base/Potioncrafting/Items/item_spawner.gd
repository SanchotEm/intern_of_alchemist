extends Node2D

@export var item_data: ItemData
@export_file("*.tscn") var item
const BASE_ITEM_SCENE = "res://Base/Potioncrafting/Items/base_item.tscn"
@onready var button: Area2D = $button

func _ready() -> void:
	button.input_event.connect(spawn)


func spawn(_viewport, event, _index):
	if not item_data:
		print("spawner missing item data")
		return
	if event.is_action_pressed("LMB") and Interface.player.hand_status == Player.HandStatus.EMPTY:
		var new_item = load(BASE_ITEM_SCENE).instantiate()
		new_item.data = item_data
		get_tree().current_scene.add_child(new_item)
		new_item.position = get_global_mouse_position()
		new_item.give_me_up.emit()
	pass
