
@icon("uid://depx31n1rqdof")
extends RigidBody2D
class_name Item

signal give_me_up(item: Item)
signal let_me_down(item: Item)

var player
enum ItemStates {NONE, HOLDED, PLACED}
var current_state := ItemStates.NONE

@onready var sprite : Sprite2D = $item_sprite
@onready var input_collision: Area2D = $input_collision
@onready var item_collision: CollisionShape2D = $Item_collision
@onready var pin: PinJoint2D = $PinJoint2D

@export var data : ItemData = load("uid://dbhko3ik5pxgr")


var drag_mode: bool = false
var pressed_pos: Vector2

func _ready() -> void:
	center_of_mass_mode=RigidBody2D.CENTER_OF_MASS_MODE_CUSTOM
	sprite.texture = data.sprite
	Interface.items.append(self)
	pin.set_node_a(get_path())
	player = Interface.player
	give_me_up.connect(player.pick.bind(self))
	let_me_down.connect(player.release.bind(self))
	input_collision.input_event.connect(got_input)

func _process(_delta: float) -> void:
	if !drag_mode and pressed_pos:
		
		var drag_distance = (get_global_mouse_position()-pressed_pos).length()
		#print("Mouse drag distance: ", drag_distance)
		if drag_distance > 20:
			drag_mode = true
			pressed_pos = Vector2(0,0)


func got_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	if drag_mode:
		if event.is_action_released("LMB"):
			if current_state == ItemStates.HOLDED:
				let_me_down.emit()
				drag_mode = false
				pass
	else:
		if event.is_action_released("LMB"):
				pressed_pos = Vector2(0,0)
		if event.is_action_pressed("LMB"):
			#print("LMB pressed - Current state: ", ItemStates.find_key(current_state))
			if current_state != ItemStates.HOLDED:
				pressed_pos = get_global_mouse_position()
				give_me_up.emit()
				pass

		if event.is_action_pressed("RMB"):
			if current_state == ItemStates.HOLDED:
				let_me_down.emit()
				pressed_pos = Vector2(0,0)
				pass
	pass
	
func attach_to(target:Node2D, connection_point: Vector2 = get_global_mouse_position()):
	if _is_attached():
		detach()
	pin.global_position = connection_point
	pin.set_node_b(target.get_path())
	Interface.play_audio(Interface.AudioPlayerType.SFX, data.item_sound)
	current_state = ItemStates.HOLDED
	
	pass

func _is_attached() -> bool:
	return !pin.node_b.is_empty()

func detach():
	current_state = ItemStates.PLACED
	pin.set_node_b("")
	Interface.play_audio(Interface.AudioPlayerType.SFX, data.item_sound)
	pass
