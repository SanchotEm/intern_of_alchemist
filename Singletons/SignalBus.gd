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

# --- Item Sigals ---
func item_grabbed(item_it :String) -> void:
	match item_it:
		"ember_twig":
			grabbed_ember_twig.emit()
		"flicker_berry":
			grabbed_flicker_berry.emit()
		"paper_shred":
			grabbed_paper_shred.emit()
		"pebble_heart":
			grabbed_pebble_heart.emit()
		"stray_feather":
			grabbed_stray_feather.emit()
		"whisper_shell":
			grabbed_whisper_shell.emit()
		"wild_lavender":
			grabbed_wild_lavander.emit()

signal grabbed_ember_twig
signal grabbed_flicker_berry
signal grabbed_paper_shred
signal grabbed_pebble_heart
signal grabbed_stray_feather
signal grabbed_whisper_shell
signal grabbed_wild_lavander

# --- Achievement & Stat Signals ---
# Signal for any stat change, simply increment by a value
signal stat_incremented(stat_name: String, value: int)

# Signal for events that might unlock an achievement, simply pass an event id
signal achievement_triggered(event_id: String)

# Misc. other signals
signal grimoire_moved
