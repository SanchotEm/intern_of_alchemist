## SignalBus - Autoload
extends Node

# --- UI Signals ---
signal grimoire_clicked
signal dev_mode_visibility_changed(is_visible: bool)
signal grimoire_recipe_selected(current_recipe_id: String)

# --- Music Signals ---
signal play_pause_music_toggled
signal music_playback_changed(is_playing: bool)
