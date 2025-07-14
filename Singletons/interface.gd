## Interface - Autoload
extends Node

var player 
var items: Array[Item] = []

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
