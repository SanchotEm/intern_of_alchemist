extends Node

var current_potion_ingredients = []

func _ready():
	pass

func register_new_ingredient(ingredient_node):
	ingredient_node.ingredient_added.connect(_on_ingredient_added_to_cauldron)

func _on_ingredient_added_to_cauldron(ingredient_data):
	print("Ingredient added: ", ingredient_data.ingredient_name)
	current_potion_ingredients.append(ingredient_data)
	
	# TODO: Add logic to check if the ingredients match the current recipe.
	
	print("Current ingredients in pot: ", current_potion_ingredients.size())

func clear_cauldron():
	current_potion_ingredients.clear()
	print("Cauldron has been cleared.")
