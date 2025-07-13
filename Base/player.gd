extends Node2D
class_name Player

enum HandStatus {EMPTY, WITH_ITEM,INTERACTING,DISABLED}
var hand
var hand_status: HandStatus = HandStatus.EMPTY
@onready var grabler: StaticBody2D = $Grabler
@onready var joint: PinJoint2D = $"../joint"



func _ready() -> void:
	joint.set_node_a(grabler.get_path())
	Interface.player = self
func pick(item: Item):
	if hand_status != HandStatus.EMPTY:
		return

	hand = item
	joint.set_node_b(hand.get_path())

	hand_status = HandStatus.WITH_ITEM
	item.current_state = item.ItemStates.HOLDED
	pass

func release() -> Item:
	var released_item
	if hand_status == HandStatus.WITH_ITEM:
		joint.set_node_b("")
		hand_status = HandStatus.EMPTY
		hand.current_state = hand.ItemStates.NONE
		released_item = hand
		hand = null
		
	return released_item
func _hand_updates():
	joint.global_position = get_global_mouse_position()
	grabler.global_position = get_global_mouse_position()
		
	pass
func _process(delta: float) -> void:
	_hand_updates()
