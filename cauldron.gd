extends Node2D

@onready var soup: Area2D = $soup

var ingredients :Array[String] = []
func _ready() -> void:
	soup.body_entered.connect(_add_to_soup)

func _add_to_soup(ingredient:Node2D):
	if ingredient is Item:
		ingredients.append_array(ingredient.tags)
		ingredient.queue_free()
	_check_soup()
	pass

func _check_soup():
	if Interface.match_recipe(ingredients):
			_create(Interface.match_recipe(ingredients))
	pass
func _create(recipe):
	print(recipe["name"])
	for i in recipe["tags"]:
		ingredients.erase(i)
	var outcome = Callable.create(self, recipe["method"])
	outcome.call()
	pass
func dummy():
	get_tree().quit()
func get_content()->Array[String]:
	return ingredients
