## Volume Control UI
extends Control


#i group all sliders under enumeration, cuz we actually are using the same methods on them all
enum AudioSlider {MAIN, SFX, NARRATOR, MUSIC}
@onready var audio_sliders : Dictionary = {
	AudioSlider.MAIN : {
		"Node":%MainVolumeVSlider,
		"AudioBusIndex":AudioServer.get_bus_index("Master")
		},
	AudioSlider.SFX : {
		"Node":%SFXVolumeVSlider,
		"AudioBusIndex":AudioServer.get_bus_index("SFX")
		},
	AudioSlider.NARRATOR : {
		"Node":%NarratorVolumeVSlider,
		"AudioBusIndex":AudioServer.get_bus_index("Narrator")
		},
	AudioSlider.MUSIC : {
		"Node":%MusicVolumeVSlider,
		"AudioBusIndex":AudioServer.get_bus_index("Music")
	}
	}
@onready var volume_button: TextureButton = %VolumeButton
@onready var volume_sliders: HBoxContainer = %VolumeSlidersHBoxContainer
@onready var main_slider: VSlider = %MainVolumeVSlider
@onready var sfx_slider: VSlider = %SFXVolumeVSlider
@onready var narrator_slider: VSlider = %NarratorVolumeVSlider

var sliders_visible := false 
func _ready() -> void:
	# Initialization
	volume_sliders.modulate.a = 0.0 # why changing alpha channel?
	volume_sliders.visible = false
	volume_button.pressed.connect(_on_volume_button_pressed)
	_setup_sliders()
	#_connect_signals()
	#_apply_initial_volumes()


#universal change_volume method for any volume slider we would add/ would change
func change_volume(value: float, slider:AudioSlider):
	AudioServer.set_bus_volume_db(
		audio_sliders[slider]["AudioBusIndex"],
		linear_to_db(value / 100.0))
	pass
func _on_volume_button_pressed() -> void:
	# Toggle slider visibility
	sliders_visible = not sliders_visible
	volume_sliders.visible = sliders_visible 
	volume_sliders.modulate.a = 1.0 if sliders_visible else 0.0
	volume_button.button_pressed = sliders_visible
func _setup_sliders() -> void:
	#better approach
	for slider in audio_sliders.keys():
		var node = audio_sliders[slider]["Node"]
		node.min_value = GameConstants.MIN_VOLUME_VALUE
		node.max_value = GameConstants.MAX_VOLUME_VALUE
		node.value = GameConstants.DEFAULT_MAIN_VOLUME
		node.value_changed.connect(change_volume.bind(slider))
		change_volume(node.value, slider)
	# Slider configuration from GameConstants
	#main_slider.min_value = GameConstants.MIN_VOLUME_VALUE
	#main_slider.max_value = GameConstants.MAX_VOLUME_VALUE
	#main_slider.value = GameConstants.DEFAULT_MAIN_VOLUME
#
	#sfx_slider.min_value = GameConstants.MIN_VOLUME_VALUE
	#sfx_slider.max_value = GameConstants.MAX_VOLUME_VALUE
	#sfx_slider.value = GameConstants.DEFAULT_SFX_VOLUME
#
	#narrator_slider.min_value = GameConstants.MIN_VOLUME_VALUE
	#narrator_slider.max_value = GameConstants.MAX_VOLUME_VALUE
	#narrator_slider.value = GameConstants.DEFAULT_NARRATOR_VOLUME


	
#func _connect_signals() -> void:
	## Signal connections
	#volume_button.pressed.connect(_on_volume_button_pressed)
	#main_slider.value_changed.connect(_on_main_volume_value_changed)
	#sfx_slider.value_changed.connect(_on_sfx_volume_value_changed)
	#narrator_slider.value_changed.connect(_on_narrator_volume_value_changed)
#
#func _apply_initial_volumes() -> void:
	## Initial volume application
	#_on_main_volume_value_changed(main_slider.value)
	#_on_sfx_volume_value_changed(sfx_slider.value)
	#_on_narrator_volume_value_changed(narrator_slider.value)
#

#
#func _on_main_volume_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(
		#AudioServer.get_bus_index("Master"),
		#linear_to_db(value / 100.0)
	#)
#
#func _on_sfx_volume_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(
		#AudioServer.get_bus_index("SFX"),
		#linear_to_db(value / 100.0)
	#)
#
#func _on_narrator_volume_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(
		#AudioServer.get_bus_index("Narrator"),
		#linear_to_db(value / 100.0)
	#)
