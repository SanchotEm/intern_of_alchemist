
@icon("uid://depx31n1rqdof")
extends RigidBody2D
class_name Item


var player
enum ItemStates {NONE, HOLDED, PLACED}
var current_state := ItemStates.NONE

@onready var sprite : Sprite2D = $item_sprite
@onready var input_collision: Area2D = $input_collision
@onready var item_collision: CollisionShape2D = $Item_collision

var item_name
var description
var tags: Array[String]
var icon


func _ready() -> void:
	Interface.items.append(self)
	player = Interface.player
	input_collision.input_event.connect(got_input)

func got_input(viewport: Node, event: InputEvent, shape_idx: int):
	
	if event.is_action_pressed("LMB"):
		print(ItemStates.find_key(current_state))
		if current_state != ItemStates.HOLDED:
			player.pick(self)
			print("click")
			return
		if current_state == ItemStates.HOLDED:
			player.release()
			print("clack")
			return
	pass
	
