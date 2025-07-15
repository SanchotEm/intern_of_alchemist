extends Node2D

enum MentorStates\
 {HIDDEN, MOVING, LINGERING, LINGERING_CLICK, LINGERING_WAVE, LINGERING_WAVE_ITEM, LINGERING_GRAB_ITEM}
var mentor_state :MentorStates = MentorStates.HIDDEN
var state_chances :Array[int] = [20, 20, 0, 0, 0]
#HIDDEN = not visible or doing anything
#MOVING = travelling across the screen, therefore not interactable
#LINGERING = On the screen, in the way, halfway transparent
 #Goes away/flies arround again on it's own after a few seconds
#LINGERING_CLICK = will get gradualy more transparent and moves arround as you click on it,
 #eventuray disapearing
#LINGERING_WAVE = idem, but or waving the mouse on its face
#LINGERING_WAVE_ITEM = idem, but waving an item (ingredient) on its face
#LINGERING_GRAB_ITEM = idem, but wants you to grab a specific item it's hovering above of

var apparition_time_range :Vector2 = Vector2(20, 40) #min and max time between aparitions (in seconds)
#IE: between being sent away and coming back again

var speech_kinds_chance = Vector3i(45, 30, 25) #chance that it will, respectivelly:
#give a hint (not necessarly related to the current recipy)
#give a *crytic* hint
#say a giberish/nonsense thing not really related to anything, but that might sound like a cryptic hint

#LINGERING
var linger_time_range = Vector2(3, 6) #min and max time between each random lingering movement (s)
var linger_amount_range = Vector2i(0, 3) #min and max amount of time mentor will move randomly when lingering

#LINGERING_CLICK
var i_t_per_click :int = 8 #increase transparency per click


func _ready() -> void:
	move_to(Vector2(500, 500))


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action("LMB"):
		if event.is_action_pressed("LMB"):
			if mentor_state == MentorStates.LINGERING_CLICK:
				pass


func show_up() -> void: #Appears in a random position, then enters a LINGERING state
	
	await move_to_random_position(true) #will allways show up on a random position
	#Might move to speciic position later, such as if it rolls LINGERING_GRAB_ITEM
	show()
	modulate = Color(1, 1, 1, 1)
	
	say_random()
	
	var sum :int = 0
	for c in state_chances:
		sum += c
	var i :int = randi_range(1, sum)
	if i <= state_chances[0]:
		pass
	elif i <= state_chances[1]:
		pass
	elif i <= state_chances[2]:
		pass
	elif i <= state_chances[3]:
		pass
	elif i <= state_chances[4]:
		pass
	#else:
		#else:
		#print("'show_up' on mentor didn't work propery. i = ", str(i))


func move_to_random_position(instant :bool = false) -> void: #Mentor moves to a random position
	
	var siz_w :Vector2 = get_window().size
	var siz_s :Vector2 = Vector2($Sprite.texture.get_width(), $Sprite.texture.get_height()) * $Sprite.scale
	var pos = Vector2(randf_range(siz_s.x/2, siz_w.x - siz_s.x/2), randf_range(siz_s.y/2, siz_w.y - siz_s.y/2))
	
	if instant:
		position = pos
	else:
		await move_to(pos)

func move_to(pos :Vector2) -> void: #Moves toward pos with an animation
	
	var starting_state :MentorStates = mentor_state
	mentor_state = MentorStates.MOVING
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", pos, 1).set_trans(Tween.TRANS_SINE)
	await tween.finished
	
	mentor_state = starting_state

func say_random() -> void:
	
	var x = speech_kinds_chance.x
	var y = x + speech_kinds_chance.y
	var z = y + speech_kinds_chance.z
	
	var file :DirAccess = DirAccess.open("res://Base/Mentor/Sentences/")
	if !file:
		print("Error! Filed to open 'res://Base/Mentor/Sentences/'. Error:")
		print(error_string(DirAccess.get_open_error()))
		return
	
	var i = randi_range(1, z)
	
	if i <= x:
		file.change_dir("Hints")
	elif x < i and i <= y:
		file.change_dir("Cryptic hints")
	elif y < i and i <= z:
		file.change_dir("Gibberish")
	#else:
	#	print("'say_speech' on mentor didn't work propery. i = ", str(i))
	
	var files = file.get_files()
	i = randi_range(0, files.size() - 1)
	
	say_sentence(load(files[i]))

func say_sentence(sentence :Sentence_Resource) -> void:
	pass


func disappear() -> void:
	hide()
	mentor_state = MentorStates.HIDDEN
	
	var timer = get_tree().create_timer(randi_range(apparition_time_range.x, apparition_time_range.y))
	timer.timeout.connect(show_up)
