extends ColorRect

signal dialogue_finished
enum SpeechBubbleStates {HIDDEN, SHOWING, ALL_VISIBLE}
var speech_bubble_state :SpeechBubbleStates = SpeechBubbleStates.HIDDEN

var visible_characters_true :float = 0 #true amount of visible characters

var player :AudioStreamPlayer #current audio player, if there is one
var saved_volume = {}
var muted = {
	0:false,
	1:false,
	2:false,
}
func _ready() -> void:
	pass
	#show_text("LOREM IPSUM [i]TEST[/i] [b]TEST[/b] TEST")

func _process(delta: float) -> void:
	if speech_bubble_state == SpeechBubbleStates.SHOWING:
		visible_characters_true += GameConstants.TEXT_SPEED * delta
		$Label.visible_characters = visible_characters_true
		if $Label.visible_ratio >= 1.0:
			speech_bubble_state = SpeechBubbleStates.ALL_VISIBLE
			if !get_player_active():
				$Timer.start(GameConstants.TEXT_TIME_TO_DISAPPEAR)

func say_sentence(sentence :Sentence_Resource) -> void:
	if not sentence:
		push_error("No sentences to say")
		return
	show_text(sentence.txt if "txt" in sentence else "PLACEHOLDER TEXT")
	if sentence.audio:
		for each in Interface.audio_players:
			if each != Interface.AudioPlayerType.NARRATOR:
				if !muted[each]: 
					saved_volume[each]=Interface.audio_players[each].volume_db
					muted[each] = true
				create_tween().tween_property(Interface.audio_players[each], "volume_db", saved_volume[each]-20, 0.5)
		player = Interface.play_audio(Interface.AudioPlayerType.NARRATOR, load(sentence.audio))
		if player and !player.finished.is_connected(_on_player_finished):
			player.finished.connect(_on_player_finished)

func _on_player_finished() -> void:
	for each in Interface.audio_players:
			if each != Interface.AudioPlayerType.NARRATOR:
				Interface.audio_players[each].volume_db = saved_volume[each]
				muted[each] = false
	if speech_bubble_state == SpeechBubbleStates.ALL_VISIBLE:
		$Timer.start(GameConstants.TEXT_TIME_TO_DISAPPEAR)

func get_player_active() -> bool:
	var player_active :bool
	if player:
		player_active = player.playing
	else:
		player_active = false
	return player_active

func show_text(txt :String, instantaneous = true) -> void:
	$Label.text = txt
	show()
	if instantaneous:
		$Label.visible_characters = -1
		speech_bubble_state = SpeechBubbleStates.ALL_VISIBLE
	else:
		speech_bubble_state = SpeechBubbleStates.SHOWING

func disappear() -> void:
	speech_bubble_state = SpeechBubbleStates.HIDDEN
	$Label.visible_characters = 0
	visible_characters_true = 0
	hide()
	dialogue_finished.emit() 

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("LMB"):
		if event.is_action_pressed("LMB"):
			match speech_bubble_state:
				SpeechBubbleStates.SHOWING:
					$Label.visible_ratio = 1.0
					speech_bubble_state = SpeechBubbleStates.ALL_VISIBLE
				
				SpeechBubbleStates.ALL_VISIBLE:
					disappear()
