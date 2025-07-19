extends Node2D
class_name Player

enum HandStatus {EMPTY, WITH_ITEM,INTERACTING,DISABLED}
var hand
var hand_status: HandStatus = HandStatus.EMPTY
@onready var grabler: StaticBody2D = $Grabler

func _input(event: InputEvent) -> void:
	if hand_status == HandStatus.WITH_ITEM:
		if event.is_action_pressed("LMB") and hand.drag_mode:
			release(hand)
		elif event.is_action_pressed("RMB") and !hand.drag_mode:
			release(hand)
			

func _enter_tree(): 
	Interface.player = self
func pick(item: Item):
	if hand_status != HandStatus.EMPTY:
		return

	hand = item
	hand.attach_to(grabler)
	hand_status = HandStatus.WITH_ITEM
	item.current_state = item.ItemStates.HOLDED
	SignalBus.stat_incremented.emit("items_picked_up",1)
	pass

func release(_item: Item) -> Item:
	var released_item
	if hand_status == HandStatus.WITH_ITEM:
		hand_status = HandStatus.EMPTY
		hand.current_state = hand.ItemStates.NONE
		hand.detach()
		released_item = hand
		hand = null
		
	return released_item

func clear_hand():
	hand = null
	hand_status = HandStatus.EMPTY

func _hand_updates():
	grabler.global_position = get_global_mouse_position()
		
	pass
func _process(_delta: float) -> void:
	_hand_updates()
