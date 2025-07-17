extends RigidBody2D
class_name Item

@export var data: IngredientData
@onready var item_sprite: Sprite2D = $item_sprite
@onready var item_collision: CollisionShape2D = $Item_collision
@onready var collision_shape_2d: CollisionShape2D = $input_collision/InputShape2D

const BASE_RADIUS = 8.0

var is_held := false
var click_offset := Vector2.ZERO

func _ready() -> void:
	if data:
		name = data.item_name
		item_sprite.texture = data.icon
		item_sprite.scale = data.scale

		if item_collision.shape is CircleShape2D:
			item_collision.shape.radius = BASE_RADIUS * data.scale.x

		if collision_shape_2d.shape is CircleShape2D:
			collision_shape_2d.shape.radius = BASE_RADIUS * data.scale.x
	else:
		push_warning("Item spawned without IngredientData!")

func _physics_process(delta: float) -> void:
	if is_held:
		global_position = get_global_mouse_position() - click_offset.rotated(rotation)

func pick_up(click_position: Vector2) -> void:
	is_held = true
	click_offset = click_position - global_position
	freeze = true

func release() -> void:
	is_held = false
	freeze = false
