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
	var player: AudioStreamPlayer
	if player_type in audio_players:
		player = audio_players[player_type]
		player.stream = stream
		player.play()
	else:
		push_error("Audio player not working")
	return player
		var audio_stream_player: AudioStreamPlayer = audio_players[player_type]
		audio_stream_player.stream = stream
		audio_stream_player.play()
	else:
		push_error("Audio player not registered for type: %s" % player_type)
#endregion 

#region Recipies

func load_recipes(file_path: String, merge: bool = true) -> bool:
	if not FileAccess.file_exists(file_path):
		return false
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	if file == null:
		return false
	var json_data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if json_data == null:
		return false
	if merge:
		recipes.merge(json_data, true)
	else:
		recipes = json_data
	return true

# Get a single recipe by its unique ID, safer if there is bad data
func get_recipe(id: String) -> Dictionary:
	return recipes.get(id, {})

# Finds a recipe that can be crafted with the provided ingredients
func find_matching_recipe(ingredients: Array) -> Dictionary:
	for recipe_id in recipes:
		var recipe_data: Dictionary = recipes[recipe_id]
		var required: Array = recipe_data.get("required_tags", [])
		
		if required.is_empty() or ingredients.size() < required.size():
			continue

		if _can_craft(ingredients, required):
			var compatible_recipe = recipe_data.duplicate()
			compatible_recipe["tags"] = required 
			return compatible_recipe

	return {}

# Helper function to check if available ingredients meet the recipe requirements
func _can_craft(available: Array, required: Array) -> bool:
	var available_copy = available.duplicate()
	for item in required:
		var found_index = available_copy.find(item)
		if found_index != -1:
			available_copy.remove_at(found_index)
		else:
			return false
	return true

#endregion

func _ready() -> void:
	load_recipes("res://Resources/recipies.json",false)
