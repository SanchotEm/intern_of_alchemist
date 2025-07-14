## Interface - Autoload
extends Node

var player 
var items: Array[Item] = []

#region Audio Control
enum AudioPlayerType {SFX, MUSIC, NARRATOR}

var audio_players := {}

func register_player(player_type: AudioPlayerType, player: AudioStreamPlayer) -> void:
	audio_players[player_type] = player

func play_audio(player_type: AudioPlayerType, stream: AudioStream) -> void:
	if player_type in audio_players:
		var player: AudioStreamPlayer = audio_players[player_type]
		player.stream = stream
		player.play()
	else:
		push_error("Audio player not working")
#endregion 
