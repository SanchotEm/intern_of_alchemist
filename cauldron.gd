extends Node2D

@onready var soup: Area2D = $soup

var ingredients: Array[String] = []

func _ready() -> void:
	soup.body_entered.connect(_on_ingredient_added)
	print("Soup pot ready. Current contents: ", ingredients)

func _on_ingredient_added(ingredient: Node2D):
	if not ingredient is Item:
		return
	ingredients.append(ingredient.name)
	print("Added ingredient: ", ingredient.name, ". Pot now contains: ", ingredients)
	ingredient.queue_free()


func _try_craft_recipe():
	var recipe = Interface.find_matching_recipe(ingredients)
	if recipe.is_empty():
		print("No recipe matched")
		return
	# TODO This will need to be reworked with new round system, triggered after player
	# completes the last step of the recipe.
	_consume_ingredients(recipe)
	_apply_recipe_effect(recipe)

func _consume_ingredients(recipe: Dictionary):
	# TODO this will need to trigger when the user tastes the potion
	ingredients.clear()
	print("Ingredients consumed. Pot is now empty.")

func _apply_recipe_effect(recipe: Dictionary):
	var effect_method = Callable(self, recipe["method"])
	if effect_method.is_valid():
		print("Applying recipe effect: ", recipe["method"])
		effect_method.call()

func dummy():
	get_tree().quit()

func get_content()->Array[String]:
	return ingredients

# --- Recipe Methods ---
## TODO
# Placeholders for the effects we can add later
func applyGlowmeltEffect():
	print("applyGlowmeltEffect")

func applySwiftHandEffect():
	print("applySwiftHandEffect")

func applyInvisibilityEffect():
	print("applyInvisibilityEffect")

func applyTattleTonicEffect():
	print("applyTattleTonicEffect")
