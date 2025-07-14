## SignalBus - Autoload
extends Node

@warning_ignore("unused_signal")

# --- UI Signals ---
signal grimoire_clicked

# --- Music Signals ---
signal play_pause_music_toggled
signal music_playback_changed(is_playing: bool)
