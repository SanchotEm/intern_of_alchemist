## Dev Mode UI Controller
# This script controls the button that opens the dev window.
extends Control

@onready var dev_mode_button: Button = %DevModeButton

func _ready() -> void:
	dev_mode_button.pressed.connect(_on_dev_functions_button_pressed)

func _on_dev_functions_button_pressed() -> void:
	SignalBus.dev_mode_visibility_changed.emit(true)
	#print("Dev mode visibility set true")
