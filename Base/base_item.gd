
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


@export var item_name :String
@export var description :String
@export var tags: Array[String]
@export var icon : Texture2D

var drag_mode: bool = false
var pressed_pos: Vector2

# Constant for SFX
const ATTACH_SOUND: AudioStream = preload("uid://bgs8a5isxl01b")

func _ready() -> void:
	Interface.items.append(self)
	pin.set_node_a(get_path())
	player = Interface.player
	give_me_up.connect(player.pick.bind(self))
	let_me_down.connect(player.release.bind(self))
	input_collision.input_event.connect(got_input)

func _process(delta: float) -> void:
	if !drag_mode and pressed_pos:
		print((get_global_mouse_position()-pressed_pos).length())
		if (get_global_mouse_position()-pressed_pos).length()>20:
			drag_mode=true
			pressed_pos = Vector2(0,0)

func got_input(viewport: Node, event: InputEvent, shape_idx: int):
	
	if event.is_action_pressed("LMB"):
		print(ItemStates.find_key(current_state))
		if current_state != ItemStates.HOLDED and !drag_mode:
			pressed_pos = get_global_mouse_position()
			give_me_up.emit()
			return
		if current_state == ItemStates.HOLDED and !drag_mode:
			let_me_down.emit()
			pressed_pos = Vector2(0,0)
			return
	if event.is_action_released("LMB"):
		if current_state == ItemStates.HOLDED and drag_mode:
			let_me_down.emit()
			drag_mode = false
	pass
	
func attach_to(target:Node2D, connection_point: Vector2 = get_global_mouse_position()):
	if _is_attached():
		detach()
	pin.global_position = connection_point
	pin.set_node_b(target.get_path())
	Interface.play_audio(Interface.AudioPlayerType.SFX, ATTACH_SOUND)
	pass

func _is_attached() -> bool:
	return !pin.node_b.is_empty()

func detach():
	pin.set_node_b("")
	Interface.play_audio(Interface.AudioPlayerType.SFX, ATTACH_SOUND)
	pass
