## Custom Cursor Controller
extends CanvasLayer

# These lines get your two cursor sprites from the scene tree.
# Make sure the node names match exactly!
@onready var regular_cursor: Sprite2D = %RegularCursor
@onready var pressed_cursor: Sprite2D = %PressedCursor


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	regular_cursor.show()
	pressed_cursor.hide()


func _process(delta: float) -> void:
	if Input.is_action_pressed("LMB"):
		regular_cursor.hide()
		pressed_cursor.show()
	else:
		regular_cursor.show()
		pressed_cursor.hide()
