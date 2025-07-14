## Scroll UI Controller
extends Control

@onready var scroll_margin_container: MarginContainer = %ScrollMarginContainer
@onready var x_button: TextureButton = %XButton

func _ready() -> void:
	SignalBus.grimoire_clicked.connect(_on_grimoire_clicked)
	x_button.pressed.connect(_on_x_button_pressed)
	hide()

func _on_grimoire_clicked() -> void:
	# Show UI when signal received
	show()

func _on_x_button_pressed() -> void:
	# Hide UI when X button pressed
	hide()
