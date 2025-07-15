## Interface - Autoload
extends Node

var player 
var items: Array[Item] = []
var recipies : Dictionary
#region Audio Control
enum AudioPlayerType {SFX, MUSIC, NARRATOR}

var audio_players := {}

func register_player(player_type: AudioPlayerType, audio_player: AudioStreamPlayer) -> void:
	audio_players[player_type] = audio_player

func play_audio(player_type: AudioPlayerType, stream: AudioStream) -> void:
	if player_type in audio_players:
		var audio_stream_player: AudioStreamPlayer = audio_players[player_type]
		audio_stream_player.stream = stream
		audio_stream_player.play()
	else:
		push_error("Audio player not registered for type: %s" % player_type)
#endregion 
#region Recipies
func load_recipies(file: String, merge: bool = true) -> Dictionary:
	var loaded_file = FileAccess.open(file,FileAccess.READ)
	if loaded_file == null:
		push_error(FileAccess.get_open_error())
	if merge:
		recipies.merge(JSON.parse_string(loaded_file.get_as_text()))
	else:
		recipies = JSON.parse_string(loaded_file.get_as_text())
	loaded_file.close()
	return recipies
	pass
func get_recipe(id:String) -> Dictionary:
	return recipies[id]
func match_recipe(ingredients:Array[String]):
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
			return get_recipe(recipe)
	return 
#endregion

func _ready() -> void:
	load_recipies("res://Resources/recipies.json",false)
