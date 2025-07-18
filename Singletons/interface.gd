## Interface - Autoload
extends Node

var player 
var items: Array[Item] = []

var recipes : Dictionary = {}

#region Audio Control
enum AudioPlayerType {SFX, MUSIC, NARRATOR}

var audio_players := {}

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
	return recipes.get(id)

func match_recipe(ingredients: Array):
	for recipe_id in recipes:
		var recipe_data: Dictionary = recipes[recipe_id]
		var required: Array = recipe_data["required_tags"]
		var strict = recipe_data["strict"]
		if required.is_empty() or ingredients.size() < required.size():
			continue
		if _can_craft(strict, ingredients, required):
			var compatible_recipe = recipe_data.duplicate()
			compatible_recipe["tags"] = required 
			return compatible_recipe

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
