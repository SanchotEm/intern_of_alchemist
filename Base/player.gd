extends Node2D
class_name Player

enum HandStatus {EMPTY, HOLDING_ITEM}
var hand_status: HandStatus = HandStatus.EMPTY
var held_item: Item = null

func _ready() -> void:
	Interface.player = self

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("LMB"):
		if hand_status == HandStatus.EMPTY:
			var space_state = get_world_2d().direct_space_state
			var mouse_pos = get_global_mouse_position()
			
			var query = PhysicsPointQueryParameters2D.new()
			query.position = mouse_pos
			query.collision_mask = 1
			
			var results: Array = space_state.intersect_point(query)
			
			if not results.is_empty():
				var target = results[0].get("collider")
				if target is Item:
					# Pass the mouse position to the hold_item function
					hold_item(target, mouse_pos)
					get_viewport().set_input_as_handled()

	elif event.is_action_released("LMB"):
		if hand_status == HandStatus.HOLDING_ITEM:
			drop_item()
			get_viewport().set_input_as_handled()

## Picks up a specific item, changing the player's state
func hold_item(item: Item, click_position: Vector2) -> void:
	if hand_status != HandStatus.EMPTY:
		return

	held_item = item
	held_item.pick_up(click_position)
	hand_status = HandStatus.HOLDING_ITEM

## Releases the currently held item
func drop_item() -> void:
	if hand_status == HandStatus.HOLDING_ITEM:
		held_item.release()
		held_item = null
		hand_status = HandStatus.EMPTY

## Use this for when an item is consumed or trashed
func clear_hand() -> void:
	if held_item:
		held_item.queue_free()
	held_item = null
	hand_status = HandStatus.EMPTY
