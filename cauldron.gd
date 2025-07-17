extends Node2D

@onready var soup: Area2D = $soup

var ingredients :Array[String] = []

func _ready() -> void:
	soup.body_entered.connect(_add_to_soup)

func _add_to_soup(ingredient:Node2D):
	if ingredient is Item:
		ingredients.append_array(ingredient.tags)
		ingredient.queue_free()
		Interface.player.clear_hand()
	_check_soup()
	pass

func _check_soup():
	# Reduced calls, save the result
	var matched_recipe = Interface.find_matching_recipe(ingredients)
	
	# Check if the dictionary is not empty
	if not matched_recipe.is_empty():
		_create(matched_recipe)

#func _check_soup():
#	if Interface.match_recipe(ingredients):
#			_create(Interface.match_recipe(ingredients))
#	pass

func _create(recipe):
	# Added a wee bit of print formatting.
	print("Created: ", recipe["name"])
	
	for tag in recipe["tags"]:
		if ingredients.has(tag):
			ingredients.erase(tag)
	
	
	#for i in recipe["tags"]:
	#	ingredients.erase(i)
	var outcome = Callable.create(self, recipe["method"])
	if outcome.is_valid():
		outcome.call()
	pass

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
