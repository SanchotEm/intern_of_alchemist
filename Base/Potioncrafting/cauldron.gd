extends Node2D


@onready var soup: Area2D = $soup
@onready var fire: Area2D = %fire
@onready var fire_timer: Timer = $fire/fire_timer
@onready var left: Area2D = $left
@onready var right: Area2D = $right

# Use this export variable to toggle debug in the console
@export var debug_mode: bool = true
@export var Fire_Time:int = 10
var fire_power:int=0
var ingredients :Array[String] = []
var stirring: bool = false
var stir_count:int=0
var current_side_spoon

func _ready() -> void:
	left.body_entered.connect(_stir.bind("left"))
	right.body_entered.connect(_stir.bind("right"))
	soup.body_entered.connect(_add_to_soup)
	fire.body_entered.connect(_add_fire)
	fire_timer.timeout.connect(func():fire_power=maxi(0,fire_power-1))
	fire_timer.start(Fire_Time)
	soup.body_exited.connect(_remove_from_soup)
	if debug_mode:
		print("Cauldron ready. Debug mode is ON")

func _add_fire(object):
	fire_power +=1
	if debug_mode:
		print("Fire fed. Power is now %d." % fire_power)
	object.queue_free()
	Interface.player.clear_hand()
	pass
func _add_to_soup(ingredient: Node2D):
	if ingredient.is_in_group("item"):
		ingredients.append_array(ingredient.data.tags)
		if debug_mode:
			print("Tag added: %s. Current ingredients: %s" % [ingredient.data.tags, ingredients])
		ingredient.queue_free()
		Interface.player.clear_hand()
		_check_soup()

	elif ingredient.is_in_group("spoon"):
		if not stirring and debug_mode:
			print("Stirring started.")
		stirring = true

func _remove_from_soup(body: Node2D):
	if body.is_in_group("spoon"):
		if stirring and debug_mode:
			print("Stirring stopped.")
		stirring = false
	
func _stir(body, side):
	print("Stir detected on side: ", side)
	if current_side_spoon != side:
		current_side_spoon = side 
		stir_count += 1
		if debug_mode:
			print("ACTION: Stir detected from '%s'. Stir count: %d" % [side, stir_count])
		if stir_count > 3:
			if ingredients.is_empty():
				if debug_mode: print("Stirred an empty pot.")
				return
			var last = ingredients.back()
			var original_last = last
			match last:
				"light_stir":
					ingredients[ingredients.size()-1] = "medium_stir"
					
				"medium_stir":
					ingredients[ingredients.size()-1] = "hard_stir"
					
				"hard_stir":
					pass
				_:
					ingredients.push_back("light_stir")
					
			print("Last ingredient after stir: ", ingredients.back())
			stir_count=0
		pass

func _check_soup():
	print("Checking soup")
	var recipe = Interface.match_recipe(ingredients)
	if recipe:
		print("Creating: ", recipe)
		_create(recipe)
	else:
		print("No recipe matched")
		print("Current ingredients: ", ingredients)
	pass

func _create(recipe):

	
	ingredients.clear()
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
