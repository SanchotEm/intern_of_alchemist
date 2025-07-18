## Interface - Autoload
extends Node

var player 
var items: Array[Item] = []
# Small typo corrected
var recipes : Dictionary = {}

#region Audio Control
enum AudioPlayerType {SFX, MUSIC, NARRATOR}

var audio_players := {}

func register_player(player_type: AudioPlayerType, audio_player: AudioStreamPlayer) -> void:
	audio_players[player_type] = audio_player

<<<<<<< Updated upstream
func play_audio(player_type: AudioPlayerType, stream: AudioStream) -> void:
	if player_type in audio_players:
		var audio_stream_player: AudioStreamPlayer = audio_players[player_type]
		audio_stream_player.stream = stream
		audio_stream_player.play()
	else:
		push_error("Audio player not registered for type: %s" % player_type)
=======
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
>>>>>>> Stashed changes
#endregion 

#region Recipies

<<<<<<< Updated upstream
func load_recipes(file_path: String, merge: bool = true) -> bool:
	# Simple check for data, early returns
=======
func load_recipes(file_path: String, merge: bool = true):
>>>>>>> Stashed changes
	if not FileAccess.file_exists(file_path):
		return
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_data = JSON.parse_string(file.get_as_text())
	file.close()
	if merge:
		recipes.merge(json_data, true)
	else:
		recipes = json_data
<<<<<<< Updated upstream
	return true
#func load_recipies(file: String, merge: bool = true) -> Dictionary:
#	var loaded_file = FileAccess.open(file,FileAccess.READ)
#	if loaded_file == null:
#		push_error(FileAccess.get_open_error())
#	if merge:
#		recipies.merge(JSON.parse_string(loaded_file.get_as_text()))
#	else:
#		recipies = JSON.parse_string(loaded_file.get_as_text())
#	loaded_file.close()
#	return recipies
#	pass

=======
>>>>>>> Stashed changes

func get_recipe(id: String) -> Dictionary:
	return recipes.get(id)

<<<<<<< Updated upstream
#func get_recipe(id:String) -> Dictionary:
#	return recipies[id]

# Finds a recipe that can be crafted with the provided ingredients
func find_matching_recipe(ingredients: Array) -> Dictionary:
=======
func match_recipe(ingredients: Array):
>>>>>>> Stashed changes
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

#func match_recipe(ingredients:Array[String]):
#	for recipe in recipies:
#		var count :int = 0
#		var we_have = ingredients.duplicate()
#		var needed: Array = recipies[recipe]["tags"].duplicate()
#		var confirmed :Array = []
#		for ingredient in needed:
#			if we_have.has(ingredient):
#				confirmed.append(ingredient)
#				we_have.remove_at(we_have.find(ingredient))
#				count +=1
#		if needed.size()==count:
#			return get_recipe(recipe)
#	return 
#endregion

func _ready() -> void:
	load_recipes("res://Resources/recipies.json",false)
