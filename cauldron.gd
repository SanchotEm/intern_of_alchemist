extends Node2D

@onready var soup: Area2D = $soup

var recipies = {
	"dummy" : 
		{
		"tags":["dummy","dummy"],
		"method" : dummy
		},
	}
var ingredients :Array[String] = []
func _ready() -> void:
	soup.body_entered.connect(add_to_soup)

func add_to_soup(ingredient:Node2D):
	print(ingredient)
	if ingredient is Item:
		print(ingredient is Item)
		ingredients.append_array(ingredient.tags)
		print(ingredients)
	check_soup()
	pass

func check_soup():
	for recipe in recipies:
		var count :int = 0
		var we_have = ingredients.duplicate()
		var needed: Array = recipies[recipe]["tags"].duplicate()
		var confirmed :Array = []
		for ingredient in needed:
			if we_have.has(ingredient):
				confirmed.append(ingredient)
				we_have.remove_at(we_have.find(ingredient))
				count +=1
		if needed.size()==count:
			create(recipe)
	pass
func create(recipe):
	for i in recipies[recipe]["tags"]:
		ingredients.erase(i)
	recipies[recipe]["method"].call()
	pass
func dummy():
	get_tree().quit()
