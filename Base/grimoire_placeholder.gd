## Grimoire placeholder
extends Sprite2D

@onready var area_2d: Area2D = $Area2D

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		SignalBus.grimoire_clicked.emit()
