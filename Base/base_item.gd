extends Node2D
class_name Item

enum item_states {NONE, HOLDED, PLACED}
var current_state := item_states.NONE
@export var data: ItemData
var sprite : Sprite2D

func _init(itemdata: ItemData) -> void:
	data = itemdata
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.texture = data.sprite
	
	pass
