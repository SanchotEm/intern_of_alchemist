extends Node2D
class_name Player

enum HandStatus {EMPTY, WITH_ITEM,INTERACTING,DISABLED}
var hand
var hand_status: HandStatus = HandStatus.EMPTY
@onready var camera_2d: Camera2D = %Camera2D
@onready var grabler: StaticBody2D = $Grabler
@onready var point_table: Marker2D = $"../Scene/PointTable"
@onready var point_cauldron: Marker2D = $"../Scene/PointCauldron"
@export var camera_speed: float = 50
var hand_help: bool = false
var direction: String
func _input(event: InputEvent) -> void:
	if hand_status == HandStatus.WITH_ITEM and hand_help:
		if event.is_action_released("LMB") and hand.drag_mode:
			
			release(hand)
			
		elif event.is_action_pressed("RMB") and !hand.drag_mode:
			hand.pressed_pos = Vector2(0,0)
			release(hand)
			

func move_camera():
	match direction:
		"left":
			global_position.x = clamp(global_position.x-pow(camera_speed,2)*get_process_delta_time(),point_table.global_position.x,point_cauldron.global_position.x)
		"right": 
			global_position.x = clamp(global_position.x+pow(camera_speed,2)*get_process_delta_time(),point_table.global_position.x,point_cauldron.global_position.x)


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
	SignalBus.item_grabbed(item.data.item_id)
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
	move_camera()
	_hand_updates()
func _ready() -> void:
	global_position=point_cauldron.global_position
