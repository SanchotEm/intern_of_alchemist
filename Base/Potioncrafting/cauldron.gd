extends Node2D


@onready var soup: Area2D = $soup
@onready var fire: Area2D = %fire
@onready var fire_timer: Timer = $fire/fire_timer
@onready var left: Area2D = $left
@onready var right: Area2D = $right


@export var Fire_Time:int = 10
var fire_power:int=0
var applied_heat: bool = false
var ingredients :Array[String] = []
var stirring: bool = false
var stir_count:int=0
var current_side_spoon

@onready var hardlock_recipe = Interface.get_recipe("glowmelt")

func _ready() -> void:
	left.body_entered.connect(_stir.bind("left"))
	right.body_entered.connect(_stir.bind("right"))
	soup.body_entered.connect(_add_to_soup)
	fire.body_entered.connect(_add_fire)
	fire_timer.timeout.connect(_reduce_fire)
	fire_timer.start(Fire_Time)
	soup.body_exited.connect(_remove_from_soup)
func _process(delta: float) -> void:
	if ingredients.size()>3:
		
		if !is_following_recipe(hardlock_recipe):
			get_tree().quit()
func is_following_recipe(recipe)->bool:
	print(recipe["required_tags"])
	for i in ingredients:
		
		if !recipe["required_tags"].has(i):
			return false
	return true
func _reduce_fire():
	fire_power=maxi(0,fire_power-1)
	if fire_power<3:
		applied_heat=false
func _add_fire(object):
	fire_power +=1
	
	object.queue_free()
	Interface.player.clear_hand()
	if fire_power >=3 and !applied_heat:
		applied_heat = true
		ingredients.append("heat")
	pass
func _add_to_soup(ingredient:Node2D):
	if ingredient.is_in_group("item"):
		ingredients.append_array(ingredient.data.tags)
		ingredient.queue_free()
		Interface.player.clear_hand()
		
	elif ingredient.is_in_group("spoon"):
		stirring = true
		ingredient.call_deferred("set_lock_rotation_enabled", true)
	pass
	
	_check_soup()
func _remove_from_soup(body):
	if body.is_in_group("spoon"):
		stirring = false
		body.call_deferred("set_lock_rotation_enabled", false)
	
func _stir(body, side):
	if current_side_spoon != side and stirring:
		stir_count+=1
		if stir_count > 3:
			var last = ingredients.back()
			match last:
				"light_stir":
					ingredients[ingredients.size()-1] = "medium_stir"
					
				"medium_stir":
					ingredients[ingredients.size()-1] = "hard_stir"
					
				"hard_stir":
					pass
				_:
					ingredients.push_back("light_stir")
					
			print(last)
			stir_count=0
		pass

func _check_soup():
	var recipe = Interface.match_recipe(ingredients)
	if recipe:
			_create(recipe[0],recipe[1])
	pass

func _create(recipe, flaws):
	print(flaws)
	print(recipe)
	
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
