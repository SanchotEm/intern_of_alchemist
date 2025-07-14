## Volume Control UI
extends Control

enum AudioSlider {MAIN, SFX, NARRATOR, MUSIC}

@onready var audio_sliders := {
	AudioSlider.MAIN: {
		"node": %MainVolumeVSlider,
		"bus_index": AudioServer.get_bus_index("Master"),
		"default": GameConstants.DEFAULT_MAIN_VOLUME
	},
	AudioSlider.SFX: {
		"node": %SFXVolumeVSlider,
		"bus_index": AudioServer.get_bus_index("SFX"),
		"default": GameConstants.DEFAULT_SFX_VOLUME
	},
	AudioSlider.NARRATOR: {
		"node": %NarratorVolumeVSlider,
		"bus_index": AudioServer.get_bus_index("Narrator"),
		"default": GameConstants.DEFAULT_NARRATOR_VOLUME
	},
	AudioSlider.MUSIC: {
		"node": %MusicVolumeVSlider,
		"bus_index": AudioServer.get_bus_index("Music"),
		"default": GameConstants.DEFAULT_MUSIC_VOLUME  
	}
}
@onready var volume_button: TextureButton = %VolumeButton
@onready var volume_sliders: HBoxContainer = %VolumeSlidersHBoxContainer

@onready var main_slider: VSlider = %MainVolumeVSlider
@onready var sfx_slider: VSlider = %SFXVolumeVSlider
@onready var narrator_slider: VSlider = %NarratorVolumeVSlider

var sliders_visible := false 

func _ready() -> void:
	volume_sliders.visible = false
	volume_sliders.modulate.a = 0.0
	volume_button.pressed.connect(_on_volume_button_pressed)
	_setup_sliders()

func _on_volume_button_pressed() -> void:
	sliders_visible = not sliders_visible
	_toggle_sliders_visibility(sliders_visible)
	volume_button.button_pressed = sliders_visible

func _toggle_sliders_visibility(should_show: bool) -> void:
	var tween = create_tween()
	if should_show:
		volume_sliders.visible = true
		tween.tween_property(volume_sliders, "modulate:a", 1.0, 0.3).set_trans(Tween.TRANS_SINE)
	else:
		tween.tween_property(volume_sliders, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_SINE)
		await tween.finished
		volume_sliders.visible = false

func _setup_sliders() -> void:
	for slider_type in audio_sliders:
		var config = audio_sliders[slider_type]
		var slider: VSlider = config["node"]
		
		slider.min_value = GameConstants.MIN_VOLUME_VALUE
		slider.max_value = GameConstants.MAX_VOLUME_VALUE
		slider.value = config["default"]
		slider.value_changed.connect(_on_volume_changed.bind(slider_type))
		_set_bus_volume(config["bus_index"], slider.value)

func _on_volume_changed(value: float, slider_type: AudioSlider) -> void:
	var bus_index = audio_sliders[slider_type]["bus_index"]
	_set_bus_volume(bus_index, value)
	
func _set_bus_volume(bus_index: int, value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value / 100.0))
