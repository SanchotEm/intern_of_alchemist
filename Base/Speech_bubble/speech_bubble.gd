extends ColorRect

enum SpeechBubbleStates {HIDDEN, SHOWING, ALL_VISIBLE}
var speech_bubble_state :SpeechBubbleStates = SpeechBubbleStates.HIDDEN

var visible_characters_true :float = 0 #true amount of visible characters

func _ready() -> void:
	show_text("LOREM IPSUM [i]TEST[/i] [b]TEST[/b] TEST")

func _process(delta: float) -> void:
	if speech_bubble_state == SpeechBubbleStates.SHOWING:
		visible_characters_true += GameConstants.TEXT_SPEED * delta
		$Label.visible_characters = visible_characters_true
		if $Label.visible_ratio >= 1.0:
			print("ALL_VISIBLE")
			speech_bubble_state = SpeechBubbleStates.ALL_VISIBLE

func show_text(txt :String) -> void:
	$Label.text = txt
	speech_bubble_state = SpeechBubbleStates.SHOWING
	show()

func disappear() -> void:
	speech_bubble_state = SpeechBubbleStates.HIDDEN
	$Label.visible_characters = 0
	visible_characters_true = 0
	hide()

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("LMB"):
		if event.is_action_pressed("LMB"):
			match speech_bubble_state:
				SpeechBubbleStates.SHOWING:
					$Label.visible_ratio = 1.0
					speech_bubble_state = SpeechBubbleStates.ALL_VISIBLE
				
				SpeechBubbleStates.ALL_VISIBLE:
					disappear()
