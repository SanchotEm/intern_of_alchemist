## Panel for the recipe display during gameplay (Corrected)
extends PanelContainer

@onready var recipe_name_label: Label = %RecipeNameLabel
@onready var recipe_instructions_label: Label = %RecipeInstructionsLabel

func _ready() -> void:
	SignalBus.grimoire_recipe_selected.connect(_on_recipe_selected)
	set_initial_state()

func _on_recipe_selected(recipe_id: String) -> void:
	var recipe_data: Dictionary = Interface.get_recipe(recipe_id)
	
	update_recipe_display(recipe_data)

func set_initial_state() -> void:
	recipe_name_label.text = "Select a Recipe"
	recipe_instructions_label.text = ""

func update_recipe_display(recipe_data: Dictionary) -> void:
	recipe_name_label.text = recipe_data.get("name", "Unknown Recipe")
	recipe_instructions_label.text = recipe_data.get("instructions", "No instructions provided.")
