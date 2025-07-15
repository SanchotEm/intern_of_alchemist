## Dev Mode Window for anything
# This is the main window for developer tools.
extends CenterContainer

@onready var spawn_item_button: Button = %SpawnItemButton
@onready var dev_functions_x_button: TextureButton = %DevFunctionsXButton


func _ready() -> void:
	visible = false
	SignalBus.dev_mode_visibility_changed.connect(_on_dev_mode_visibility_changed)
	dev_functions_x_button.pressed.connect(_on_dev_functions_x_button_pressed)
	spawn_item_button.pressed.connect(_on_spawn_item_button_pressed)


func _on_dev_mode_visibility_changed(is_visible_flag: bool) -> void:
	visible = is_visible_flag

func _on_dev_functions_x_button_pressed() -> void:
	SignalBus.dev_mode_visibility_changed.emit(false)
	#print("Dev mode visibility set false.")

func _on_spawn_item_button_pressed() -> void:
	# TODO: Implement item spawning logic here.

	var item = load("res://Base/base_item.tscn").instantiate()
	item.global_position = %Marker2D.position
	print(item.position)
	%Level.add_child(item)
	pass 
