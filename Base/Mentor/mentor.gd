extends Node2D

enum MentorStates\
 {HIDDEN, MOVING, LINGERING, LINGERING_CLICK, LINGERING_WAVE, LINGERING_WAVE_ITEM, LINGERING_GRAB_ITEM}
var mentor_state :MentorStates = MentorStates.HIDDEN
var state_chances :Array[int] = [20, 20, 20, 0, 0]
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

var apparition_time_range :Vector2 = Vector2(20, 40) #min and max time between aparitions (in seconds)
#IE: between being sent away and coming back again

var speech_kinds_chance = Vector3i(45, 30, 25) #chance that it will, respectivelly:
#give a hint (not necessarly related to the current recipy)
#give a *crytic* hint
#say a giberish/nonsense thing not really related to anything, but that might sound like a cryptic hint

#LINGERING
var linger_time_range = Vector2(3, 6) #min and max time between each random lingering movement (s)
var linger_amount_range = Vector2i(1, 4) #min and max amount of time mentor will move randomly when lingering
var remaining_linger_amount :int = 0

#LINGERING_CLICK
var i_t_per_click :float = 0.08 #increase transparency per click
var l_c_threshold = Vector2(0.6, 0.2)

#LINGERING_WAVE
var mouse_last_pos :Vector2 #last position the mouse was seen at
#var mouse_last_t :float = 0 #moment at wich the mouse was last seen
var mouse_on_top_lf :bool #if the mouse was On Top Of the Mentor Last Frame
var i_t_wave_rate :float = 2 * pow(10, -7) #rate at wich the master will grow transparent while bein waved at


func _ready() -> void:
	randomize()
	show_up()

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

func is_mouse_on_top(mouse_pos :Vector2) -> bool: #returns true is the mouse is on top, false otherwise
	
	var siz_s :Vector2 = get_size_sprite()
	
	var x :bool = mouse_pos.x < (position.x + siz_s.x/2) and mouse_pos.x > (position.x - siz_s.x/2)
	var y :bool = mouse_pos.y < (position.y + siz_s.y/2) and mouse_pos.y > (position.y - siz_s.y/2)
	
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
	#else:
		#else:
		#print("'show_up' on mentor didn't work propery. i = ", str(i))


func linger_to_random() -> void:
	#just moves arround being in the way a couple times
	
	remaining_linger_amount -= 1
	
	move_to_random_position()
	
	var timer = get_tree().create_timer(randf_range(linger_time_range.x, linger_time_range.y))
	if remaining_linger_amount > 0:
		timer.connect("timeout", linger_to_random)
	else:
		await timer.timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.2).set_trans(Tween.TRANS_SINE)
		await tween.finished
		
		disappear()


func move_to_random_position(instant :bool = false) -> void: #Mentor moves to a random position
	
	var siz_w :Vector2 = get_window().size
	var siz_s :Vector2 = get_size_sprite()
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
	
	say_sentence(load(file.get_current_dir() + "/" + files[i])) #WARNING:might not be safe. Check better way

func say_sentence(sentence :Sentence_Resource) -> void:
	pass


func disappear() -> void:
	hide()
	$Area2D.hide()
	mentor_state = MentorStates.HIDDEN
	
	var timer = get_tree().create_timer(randi_range(apparition_time_range.x, apparition_time_range.y))
	timer.timeout.connect(show_up)


func get_size_sprite() -> Vector2:
	return Vector2($Sprite.texture.get_width(), $Sprite.texture.get_height()) * $Sprite.scale
