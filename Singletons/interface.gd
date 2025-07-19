## Interface - Autoload
extends Node

enum languages {EN, RU}
var current_language := languages.EN:
	set(value):
		
		match value:
			languages.EN:
				TranslationServer.set_locale("en")
			languages.RU:
				TranslationServer.set_locale("ru")
		current_language=value

var player 
var items: Array[Item] = []

var recipes : Dictionary = {}

#region Audio Control
enum AudioPlayerType {SFX, MUSIC, NARRATOR}

var audio_players := {}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change language"):
		var change_lang = current_language+1
		if change_lang == languages.size():
			current_language=0
		else: current_language=change_lang
		

func register_player(player_type: AudioPlayerType, audio_player: AudioStreamPlayer) -> void:
	audio_players[player_type] = audio_player

func play_audio(player_type: AudioPlayerType, stream: AudioStream) -> AudioStreamPlayer:
	if player_type in audio_players:
		var player := audio_players[player_type] as AudioStreamPlayer
		if not is_instance_valid(player):
			push_error("Registered audio player for type '%s' is invalid or has been freed." % player_type)
			return null
		if not is_instance_valid(stream):
			push_error("Check the audio resource")
			return null
		player.stream = stream
		player.play()
		return player
	push_error("Audio player not registered for type: %s" % player_type)
	return null
#endregion 

#region Recipies

func load_recipes(file_path: String, merge: bool = true):
	if not FileAccess.file_exists(file_path):
		return
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	file.close()
	if merge:
		recipes.merge(json_data, true)
	else:
		recipes = json_data
		
func get_recipe(id: String) -> Dictionary:
	return recipes[id]

func match_recipe(ingredients: Array):
	for recipe_id in recipes:
		var recipe_data: Dictionary = recipes[recipe_id]
		var required: Array = recipe_data["required_tags"]
		var strict = recipe_data["strict"]
		if required.is_empty() or ingredients.size() < required.size():
			continue
		if _can_craft(strict, ingredients, required):
			var compatible_recipe = recipe_data.duplicate()
			var flaws = _get_flaws(compatible_recipe, ingredients)
			return [compatible_recipe, flaws]
func _get_flaws(recipe, ingredients):
	for entry in recipe["required_tags"]:
		ingredients.erase(entry)
	return ingredients
func _can_craft(strict: bool, available: Array, required: Array) -> bool:
	var available_copy: Array = available.duplicate()
	if strict:
		for item in required:
			var index = required.find(item)
			if item != available_copy[index]:
				return false
	else:
		for item in required:
			if !available_copy.has(item):
				return false
			available_copy.erase(item)
	return true

#endregion

func _ready() -> void:
	load_recipes("res://Resources/recipies.json",false)
