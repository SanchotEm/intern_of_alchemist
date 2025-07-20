## Main Menu Controller
# Manages the state of the Main Menu.
extends Control

@onready var play_button: Button = %PlayButton


func _ready() -> void:
	TranslationServer.set_locale(OS.get_locale())
	play_button.pressed.connect(_on_play_button_pressed)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("uid://blnydnqk036lx"))
