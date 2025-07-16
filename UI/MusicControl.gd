## Music UI Controller
extends Control

const PAUSE_TEXTURE = preload("res://Resources/Icons/PauseButtonSprite-0002.png")
const PLAY_TEXTURE = preload("res://Resources/Icons/PlayButtonSprite-0003.png")

@onready var pause_play_music_button: TextureButton = %PausePlayMusicButton

func _ready() -> void:
	pause_play_music_button.pressed.connect(_on_pause_play_button_pressed)
	SignalBus.music_playback_changed.connect(_on_music_playback_changed)

func _on_pause_play_button_pressed() -> void:
	SignalBus.emit_signal("play_pause_music_toggled")

func _on_music_playback_changed(is_playing: bool) -> void:
	if is_playing:
		pause_play_music_button.texture_normal = PAUSE_TEXTURE
		pause_play_music_button.tooltip_text = "Pause Music"
	else:
		pause_play_music_button.texture_normal = PLAY_TEXTURE
		pause_play_music_button.tooltip_text = "Play Music"
