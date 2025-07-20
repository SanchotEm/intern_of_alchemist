extends Node2D


@onready var soup: Area2D = $soup
@onready var fire: Area2D = %fire
@onready var fire_timer: Timer = $fire/fire_timer
@onready var left: Area2D = $left
@onready var right: Area2D = $right
@onready var ligth: Sprite2D = $ligth
@onready var point_light_2d: PointLight2D = $ligth/PointLight2D
var bubbles :AudioStreamPlayer
# Use this export variable to toggle debug in the console
@export var debug_mode: bool = true
@export var Fire_Time:int = 10
var fire_power:int=0
var applied_heat: bool = false
var ingredients :Array[String] = []
var stirring: bool = false
var stir_count:int=0
var current_side_spoon
@onready var fill: Area2D = %fill

@onready var hardlock_recipe = Interface.get_recipe("glowmelt")

func _ready() -> void:
	left.body_entered.connect(_stir.bind("left"))
	right.body_entered.connect(_stir.bind("right"))
	soup.body_entered.connect(_add_to_soup)
	fire.body_entered.connect(_add_fire)
	fire_timer.timeout.connect(_reduce_fire)
	fire_timer.start(Fire_Time)
	soup.body_exited.connect(_remove_from_soup)
	fill.mouse_entered.connect(flask)
func _process(delta: float) -> void:
	if ingredients.size()>3:
		if !is_following_recipe(hardlock_recipe):
			get_tree().quit()
func is_following_recipe(recipe)->bool:
	for i in ingredients:
		if !recipe["required_tags"].has(i):
			return false
	return true
func _reduce_fire():
	fire_power=maxi(0,fire_power-1)
	if fire_power<3:
		applied_heat=false
		ligth.hide()
func _add_fire(object):
	fire_power +=1
	object.queue_free()
	Interface.player.clear_hand()
	if fire_power >=3 and !applied_heat:
		applied_heat = true
		ingredients.append("heat")
		ligth.show()
		bubbles = Interface.play_audio(Interface.AudioPlayerType.SFX, load("uid://by7e1pfgyevys"))
		SignalBus.increased_heat
	pass
func _add_to_soup(ingredient: Node2D):
	if ingredient.is_in_group("item"):
		ingredients.append_array(ingredient.data.tags)
		ingredient.queue_free()
		Interface.player.clear_hand()
		SignalBus.item_placed(ingredient.data.item_id)
	
	elif ingredient.is_in_group("spoon"):
		stirring = true
		ingredient.call_deferred("set_lock_rotation_enabled", true)
	pass
	
func _remove_from_soup(body: Node2D):
	if body.is_in_group("spoon"):
		stirring = false
		stir_count = 0
		body.call_deferred("set_lock_rotation_enabled", false)
	
func _stir(body, side):
	if !stirring:
		return
	if current_side_spoon != side:
		current_side_spoon = side 
		stir_count += 1
		if stir_count > 3:
			if ingredients.is_empty():
				return
			var last = ingredients.back()
			match last:
				"light_stir":
					ingredients[ingredients.size()-1] = "medium_stirring"
					
				"medium_stir":
					ingredients[ingredients.size()-1] = "hard_stirring"
					
				"hard_stir":
					pass
				_:
					ingredients.push_back("light_stirring")
					
					SignalBus.light_stirr
			stir_count=0
			Interface.play_audio(Interface.AudioPlayerType.SFX, load("uid://bgm1xts2v75dy"))
		pass
func flask(body):
	print("Sssss")
	if body.is_in_group("flask"):
			var check = _check_soup()
			if check:
				Interface.player.hand.set_potion(check[0],check[1])
					
				
		
	pass
func _check_soup():
	var recipe = Interface.match_recipe(ingredients)
	if recipe:
			ingredients.clear()
			return recipe


func _create(recipe, flaws):
	
	
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
