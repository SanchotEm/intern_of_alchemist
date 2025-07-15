## SignalBus - Autoload
extends Node

@warning_ignore("unused_signal")

# --- UI Signals ---
signal grimoire_clicked
signal dev_mode_visibility_changed(is_visible: bool)

# --- Music Signals ---
signal play_pause_music_toggled
signal music_playback_changed(is_playing: bool)
