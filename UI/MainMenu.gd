## Main Menu Controller
# Manages the state of the Main Menu.
extends Control

@onready var play_button: Button = %PlayButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)


func _on_play_button_pressed() -> void:
	hide()
