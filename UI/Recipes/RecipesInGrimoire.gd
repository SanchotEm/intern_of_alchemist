## Recipes in the Grimoire
# Instantiate these into the grid container
extends PanelContainer

@onready var recipe_name_label: Label = %RecipeNameLabel
@onready var recipe_description_label: Label = %RecipeDescriptionLabel
@onready var select_recipe_button: Button = %SelectRecipeButton
@onready var recipe_texture_rect: TextureRect = %RecipeTextureRect

var current_recipe_id: String

func setup(recipe_data: Dictionary, id: String):
	current_recipe_id = id
	recipe_name_label.text = recipe_data.get("name", "Unknown Recipe")
	recipe_description_label.text = recipe_data.get("description", "No description available.")
	var icon_path = recipe_data.get("icon_path", "")
	recipe_texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	recipe_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if not icon_path.is_empty() and FileAccess.file_exists(icon_path):
		recipe_texture_rect.texture = load(icon_path)
	else:
		push_error("Icon texture not found: %s" % icon_path)
	select_recipe_button.pressed.connect(_on_select_button_pressed)

func _on_select_button_pressed():
	## TODO
	# Add some kind of recipe selection logic.
	SignalBus.emit_signal("grimoire_recipe_selected", current_recipe_id)
	print("Player selected recipe: ", current_recipe_id)
