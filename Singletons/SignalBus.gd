## SignalBus - Autoload
extends Node

# --- UI Signals ---
signal grimoire_opened
signal dev_mode_visibility_changed(is_visible: bool)
signal grimoire_recipe_selected(current_recipe_id: String)

# --- Music Signals ---
signal volume_system_ready
signal play_pause_music_toggled
signal music_playback_changed(is_playing: bool)

# --- Achievement & Stat Signals ---
# Signal for any stat change, simply increment by a value
signal stat_incremented(stat_name: String, value: int)

# Signal for events that might unlock an achievement, simply pass an event id
signal achievement_triggered(event_id: String)

# Misc. other signals
signal grimoire_moved
