## Recipes Grid Container, will spawn the recipes into the container
extends GridContainer

const RECIPE_ENTRY_SCENE = preload("res://UI/Recipes/RecipesInGrimoire.tscn")

func _ready():
	await get_tree().process_frame
	_populate_grid()

func _populate_grid():
	if not Interface or Interface.recipes.is_empty():
		push_warning("Problem loading recipes into Grimoire.")
		return
	# Clear placeholders/existing data
	for child in get_children():
		child.queue_free()
	# Loop each recipe into the grid
	for recipe_id in Interface.recipes:
		var recipe_data = Interface.recipes[recipe_id]
		var entry_instance = RECIPE_ENTRY_SCENE.instantiate()
		add_child(entry_instance)
		entry_instance.setup(recipe_data, recipe_id)
