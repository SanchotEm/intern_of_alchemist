## Music Player
extends AudioStreamPlayer

func _ready() -> void:
	await SignalBus.volume_system_ready
	play()
	SignalBus.play_pause_music_toggled.connect(_on_play_pause_toggled)
	SignalBus.emit_signal("music_playback_changed", playing)

func _on_play_pause_toggled() -> void:
	self.stream_paused = not self.stream_paused
	if not playing and not stream_paused:
		play()
	SignalBus.emit_signal("music_playback_changed", playing and not stream_paused)
