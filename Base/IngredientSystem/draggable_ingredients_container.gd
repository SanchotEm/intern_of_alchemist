extends Control

@export var item_scene: PackedScene
@export var ingredient_resources: Array[IngredientData]

@onready var player = Interface.player 

func _ready() -> void:
	var icons = $HBoxContainer.get_children()
	for i in range(min(icons.size(), ingredient_resources.size())):
		if icons[i] is TextureRect and ingredient_resources[i]:
			icons[i].texture = ingredient_resources[i].icon
			icons[i].gui_input.connect(func(event): _on_icon_clicked(event, i))

func _on_icon_clicked(event: InputEvent, index: int) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()):
		return
	if not item_scene:
		push_error("Item scene not set in the inspector.")
		return
	if index >= ingredient_resources.size() or not ingredient_resources[index]:
		push_error("No valid ingredient resource for index %d" % index)
		return
	var new_item := item_scene.instantiate() as Item
	new_item.data = ingredient_resources[index]
	new_item.global_position = get_global_mouse_position()
	get_tree().root.add_child(new_item)
	player.hold_item(new_item, new_item.global_position)
