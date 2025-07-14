extends Node
enum AudioPlayers {SFX, MUSIC, NARRATOR}
var player
var items: Array[Item] = []

var sfx_player :AudioStreamPlayer :
	set(value):
		list_of_audioplayer[AudioPlayers.SFX] = value
		sfx_player = value
var music_player :AudioStreamPlayer:
	set(value):
		list_of_audioplayer[AudioPlayers.MUSIC] = value
		music_player = value
var narrator_player :AudioStreamPlayer:
	set(value):
		list_of_audioplayer[AudioPlayers.NARRATOR] = value
		narrator_player = value
var list_of_audioplayer = {
	AudioPlayers.SFX : sfx_player,
	AudioPlayers.MUSIC : music_player,
	AudioPlayers.NARRATOR : narrator_player,
}
func play_audio(type: AudioPlayers, audio):
	
	list_of_audioplayer[type].get_stream_playback().play_stream(audio)
	pass
