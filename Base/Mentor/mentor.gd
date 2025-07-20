extends Node2D

@onready var base_scale :Vector2 = scale

@onready var narrator_audio_player: AudioStreamPlayer = %NarratorPlayer

@onready var camera_2d: Camera2D = %Camera2D


signal scripted_dialogue_finished
@export var intro_dialogue: Array[Sentence_Resource] # Array for intro lines
@export var tutorial_dialogue: Array[Sentence_Resource] # Array for tutorial lines

#sentence = the path to the resource to be loaded at that point
#callables = all callables to be called, in order
#variables = variables, each variable being used for the callable in the same index
 #if no variale necessary put null and no variable will be used
 #each callable can only have one variable, and it will be the first one used
#signal_to_wait = signal it will wait for before continuing
@onready var speech_bubble: ColorRect = %Speech_bubble
@onready var intro_actions :Array[Dictionary] = [
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished}
]
@onready var tutorial_actions :Array[Dictionary] = [
	{"callables": [move_to], "variables": [Vector2(-950, -320)], "signal_to_wait": SignalBus.grimoire_opened},
	{"callables": [], "variables": [], "signal_to_wait": SignalBus.grabbed_wild_lavander},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished},
	{"callables": [], "variables": [], "signal_to_wait": speech_bubble.dialogue_finished}
]

enum MentorStates {HIDDEN, MOVING, SCRIPTED,\
 LINGERING, LINGERING_CLICK, LINGERING_WAVE, LINGERING_WAVE_ITEM, LINGERING_GRAB_ITEM, JUMPSCARE}
var mentor_state :MentorStates = MentorStates.HIDDEN
var state_chances :Array[int] = [20, 20, 16, 0, 0, 3]
#HIDDEN = not visible or doing anything
#MOVING = travelling across the screen, therefore not interactable
#LINGERING = On the screen, in the way, halfway transparent
 #Goes away/flies arround again on it's own after a few seconds
#LINGERING_CLICK = will get gradualy more transparent and moves arround as you click on it,
 #eventuray disapearing
#LINGERING_WAVE = idem, but or waving the mouse on its face
#LINGERING_WAVE_ITEM = idem, but waving an item (ingredient) on its face
#LINGERING_GRAB_ITEM = idem, but wants you to grab a specific item it's hovering above of

var minimum_trans_to_disappear :float = 0.05 #minimum transparency at wich it will disappear

var apparition_time_range :Vector2 = Vector2(2.0, 4.0) #min and max time between aparitions (in seconds)
#IE: between being sent away and coming back again

#LINGERING
var linger_time_range = Vector2(.3, .6) #min and max time between each random lingering movement (s)
var linger_amount_range = Vector2i(10, 40) #min and max amount of time mentor will move randomly when lingering
var remaining_linger_amount :int = 0

#LINGERING_CLICK
var i_t_per_click :float = 0.08 #increase transparency per click
var l_c_threshold = Vector2(0.6, 0.2)

#LINGERING_WAVE
var mouse_last_pos :Vector2 #last position the mouse was seen at
#var mouse_last_t :float = 0 #moment at wich the mouse was last seen
var mouse_on_top_lf :bool #if the mouse was On Top Of the Mentor Last Frame
var i_t_wave_rate :float = 2.5 * pow(10, -7) #rate at wich the master will grow transparent while bein waved at

#JUMPSCARE
var time_before_fading :float = 0.8 #time before the mentor will start fading after a jumpscare, in seconds
var fading_rate :float = 1 #how much it will fade per second once it starts fading
var time_jumpscare :float #the moment the current jumpscare happened

@export var cryptic_hints: Array[Sentence_Resource]
@export var gibberish_lines: Array[Sentence_Resource]
@export var normal_hints: Array[Sentence_Resource]

@export var faliure_barks: Array[Sentence_Resource] #Things he says on a failed potion
@export var success_barks: Array[Sentence_Resource] #Things he says on a successful potion

func _ready() -> void:
	Interface.register_player(Interface.AudioPlayerType.NARRATOR, narrator_audio_player)
	randomize()
	#show_up() Hiding for the intro scene
	hide()
	$Area2D.hide()
	mentor_state = MentorStates.HIDDEN

func intro_sequence() -> void:
	mentor_state = MentorStates.SCRIPTED
	show()
	modulate = Color(1, 1, 1, 1)
	for i in intro_actions.size():
		var wait_for_bubble = intro_actions[i]["signal_to_wait"] == speech_bubble.dialogue_finished
		speech_bubble.say_sentence(intro_dialogue[i], wait_for_bubble)
		await do_action(intro_actions[i])

func tutorial(save_state :bool = true) -> void:
	var info :Dictionary
	if save_state:
		info = pause_lingering()
	
	for i in tutorial_actions.size():
		var wait_for_bubble = tutorial_actions[i]["signal_to_wait"] == speech_bubble.dialogue_finished
		speech_bubble.say_sentence(tutorial_dialogue[i], wait_for_bubble)
		await do_action(tutorial_actions[i])
	if !save_state:
		scripted_dialogue_finished.emit()
	
	if save_state:
		unpause_lingering(info)

func do_action(action :Dictionary) -> void:
	
	for i in action["callables"].size():
		if action["variables"][i]: #if there is a variable, use it
			action["callables"][i].call(action["variables"][i])
		else: #if not, call it without any variables
			action["callables"][i].call()
	
	await action["signal_to_wait"]

func say_line_and_wait(sentence: Sentence_Resource) -> void:
	speech_bubble.say_sentence(sentence)
	await speech_bubble.dialogue_finished

func _process(delta: float) -> void:
	if mentor_state == MentorStates.LINGERING_WAVE:
		var mouse_current_pos :Vector2 = get_global_mouse_position()
		if is_mouse_on_top(mouse_current_pos):
			if mouse_on_top_lf: #if it was on top this frame AND the previous, it waves away!
				var speed = get_dis(mouse_last_pos, mouse_current_pos)/(delta)
				modulate = Color(modulate.r, modulate.g, modulate.b, modulate.a - i_t_wave_rate * speed)
				if modulate.a <= minimum_trans_to_disappear: #once transparent enought, it is gone!
					disappear()
			mouse_on_top_lf = true #independent of weather it was on top last frame, it was on this one
		else: #if mouse isn't on top, just saves that it wasn't
			mouse_on_top_lf = false
		mouse_last_pos = mouse_current_pos
	elif mentor_state == MentorStates.JUMPSCARE:
		if Time.get_ticks_msec() >= time_jumpscare + time_before_fading * 1000:
			modulate = Color(modulate.r, modulate.g, modulate.b, modulate.a - fading_rate * delta)
			if modulate.a <= minimum_trans_to_disappear: #once transparent enought, it is gone!
				scale = base_scale
				disappear()

func is_mouse_on_top(mouse_pos :Vector2) -> bool: #returns true is the mouse is on top, false otherwise
	
	var siz_s :Vector2 = get_size_sprite()
	
	var x: bool = mouse_pos.x < (global_position.x + siz_s.x / 2) and mouse_pos.x > (global_position.x - siz_s.x / 2)
	var y: bool = mouse_pos.y < (global_position.y + siz_s.y / 2) and mouse_pos.y > (global_position.y - siz_s.y / 2)
	
	return x and y

func get_dis(pos1 :Vector2, pos2 :Vector2) -> float:
	return pow((pos1.x - pos2.x)**2 + (pos1.y - pos2.y)**2, 0.5)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action("LMB"):
		if event.is_action_pressed("LMB"):
			match mentor_state:
				MentorStates.LINGERING_CLICK:
					var starting_a = modulate.a
					modulate = Color(modulate.r, modulate.g, modulate.b, modulate.a - i_t_per_click)
					var current_a = modulate.a
					
					if starting_a > l_c_threshold.x and l_c_threshold.x > current_a or\
					 starting_a > l_c_threshold.y and l_c_threshold.y > current_a:
						move_to_random_position()
					elif current_a <= minimum_trans_to_disappear:
						disappear()
	#elif event is InputEventMouseMotion:
	#	print(event.position)
	#	match mentor_state:
	#		MentorStates.LINGERING_WAVE:
	#			if mouse_slf:
	#				pass
	#			else:
	#				mouse_last_pos = event.position
	#				mouse_last_t = Time.get_ticks_msec()
	#				mouse_slf = true


func show_up() -> void: #Appears in a random position, then enters a LINGERING state
	
	await move_to_random_position(true) #will allways show up on a random position
	#Might move to speciic position later, such as if it rolls LINGERING_GRAB_ITEM
	show()
	modulate = Color(1, 1, 1, 1)
	
	say_random()
	
	var sum :int = 0
	for c in state_chances:
		sum += c
	
	var chance_0 :int = state_chances[0]
	var chance_1 :int = chance_0 + state_chances[1]
	var chance_2 :int = chance_1 + state_chances[2]
	var chance_3 :int = chance_2 + state_chances[3]
	var chance_4 :int = chance_3 + state_chances[4]
	var chance_5 :int = chance_4 + state_chances[5]
	
	var i :int = randi_range(1, sum)
	if i <= chance_0: #LINGERING
		mentor_state = MentorStates.LINGERING
		remaining_linger_amount = randi_range(linger_amount_range[0], linger_amount_range[1])
		modulate = Color(1, 1, 1, 0.5)
		linger_to_random()
	elif i <= chance_1: #LINGERING_CLICK
		$Area2D.show()
		mentor_state = MentorStates.LINGERING_CLICK
	elif i <= chance_2: #LINGERING_WAVE
		mouse_last_pos = get_global_mouse_position()
		mouse_on_top_lf = false
		mentor_state = MentorStates.LINGERING_WAVE
	elif i <= chance_3: #LINGERING_WAVE_ITEM
		mentor_state = MentorStates.LINGERING_WAVE_ITEM
	elif i <= chance_4: #LINGERING_GRAB_ITEM
		mentor_state = MentorStates.LINGERING_GRAB_ITEM
	elif i <= chance_5:
		mentor_state = MentorStates.JUMPSCARE
		scale = base_scale * 5
		move_to_center()
		time_jumpscare = Time.get_ticks_msec()
		show()
	#else:
		#else:
		#print("'show_up' on mentor didn't work propery. i = ", str(i))


func linger_to_random() -> void:
	#just moves arround being in the way a couple times
	
	remaining_linger_amount -= 1
	
	await move_to_random_position()
	
	if remaining_linger_amount > 0:
		$LingerToRandomTimer.start(randf_range(linger_time_range.x, linger_time_range.y))
	else:
		
		$GenericTimer.start(randf_range(linger_time_range.x, linger_time_range.y))
		await $GenericTimer.timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2).set_trans(Tween.TRANS_SINE)
		await tween.finished
		
		disappear()

func get_camera_view_rect() -> Rect2:
	if not is_instance_valid(camera_2d):
		push_error("Can't find camera")
		return Rect2()
	var viewport_size = get_viewport_rect().size
	var view_size = viewport_size * camera_2d.zoom
	var view_top_left = camera_2d.global_position - (view_size / 2.0)
	return Rect2(view_top_left, view_size)

func move_to_random_position(instant: bool = false) -> void: # Mentor moves to a random position
	var view_rect: Rect2 = get_camera_view_rect()
	if view_rect.size == Vector2.ZERO:
		return
	var top_left: Vector2 = view_rect.position
	var bottom_right: Vector2 = view_rect.position + view_rect.size
	var siz_s: Vector2 = get_size_sprite()
	var pos = Vector2(
		randf_range(top_left.x + siz_s.x / 2.0, bottom_right.x - siz_s.x / 2.0),
		randf_range(top_left.y + siz_s.y / 2.0, bottom_right.y - siz_s.y / 2.0)
	)
	if instant:
		global_position = pos
	else:
		await move_to(pos)

func move_to_center() -> void:
	var view_rect: Rect2 = get_camera_view_rect()
	if view_rect.size != Vector2.ZERO:
		global_position = view_rect.position + view_rect.size/2 + Vector2(0, get_size_sprite().y/4)

func move_to(pos :Vector2) -> void: #Moves toward pos with an animation
	var starting_state: MentorStates = mentor_state
	mentor_state = MentorStates.MOVING
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", pos, 0.25).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	mentor_state = starting_state

func say_random() -> void:
	var sentence_type = randi_range(0, 2)
	var chosen_sentence: Sentence_Resource
	
	match sentence_type:
		0: # Normal Hint
			if not normal_hints.is_empty():
				chosen_sentence = normal_hints.pick_random()
		1: # Cryptic Hint
			if not cryptic_hints.is_empty():
				chosen_sentence = cryptic_hints.pick_random()
		2: # Gibberish
			if not gibberish_lines.is_empty():
				chosen_sentence = gibberish_lines.pick_random()
	if chosen_sentence:
		speech_bubble.say_sentence(chosen_sentence)
	else:
		print("No sentences available for the chosen category.")

func disappear() -> void:
	hide()
	$Area2D.hide()
	mentor_state = MentorStates.HIDDEN
	
	$ShowUpTimer.start(randi_range(apparition_time_range.x, apparition_time_range.y))


func get_size_sprite() -> Vector2:
	return Vector2($Sprite.texture.get_width(), $Sprite.texture.get_height()) * $Sprite.scale * scale


func _on_faliure() -> void: #called when a potion fails
	if !faliure_barks.is_empty():
		await pause_to_say(faliure_barks.pick_random())
	else:
		print("Faliure Bark!")

func _on_success() -> void: #called when a poition succeeds
	if !success_barks.is_empty():
		await pause_to_say(success_barks.pick_random())
	else:
		print("Success Bark!")

func pause_to_say(sentence :Sentence_Resource) -> void: #stops any random things he might be saying
	var info = pause_lingering()
	
	await say_line_and_wait(sentence)
	
	unpause_lingering(info)

func pause_lingering() -> Dictionary: #pause the random stuff he's doing
	var info :Dictionary = {}
	
	for t in get_tree().get_nodes_in_group("MentorTimer"):
		t.paused = true
	info["state"] = mentor_state
	mentor_state = MentorStates.SCRIPTED
	info["modulate"] = modulate
	modulate = Color(1, 1, 1, 1)
	info["visible"] = visible
	visible = true
	info["position"] = position
	info["sacle"] = scale
	scale = base_scale
	
	return info

func unpause_lingering(info :Dictionary) -> void: #continue the random stuff he's doing
	
	for t in get_tree().get_nodes_in_group("MentorTimer"):
		t.paused = false
	mentor_state = info["state"]
	modulate = info["modulate"]
	visible = info["visible"]
	position = info["position"]
	scale = info["scale"]
