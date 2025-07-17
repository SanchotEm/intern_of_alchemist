extends Node2D

@onready var hold_area: Area2D = %HoldArea2D
@onready var hold_timer: Timer = %HoldTimer
@onready var hold_progress_bar: ProgressBar = %HoldProgressBar

enum State { IDLE, HOLDING, DRAGGING, OPENED }

const PROGRESS_BAR_OFFSET: Vector2 = Vector2(-10, -20)
const MINIMUM_HOLD_TIME: float = 1.0
const DEBUG_ENABLED: bool = true

var current_state: State = State.IDLE
var drag_offset: Vector2 = Vector2.ZERO
var hold_time: float = 0.0

func _ready() -> void:
	hold_area.input_event.connect(_on_hold_area_input_event)
	hold_area.mouse_exited.connect(_on_hold_area_mouse_exited)
	hold_progress_bar.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_released("LMB"):
		return
		
	match current_state:
		State.HOLDING:
			print("Hold released after ", hold_time, "s")
			_cancel_hold()
			if hold_time < MINIMUM_HOLD_TIME:
				print("Emitting click (short hold)")
				SignalBus.emit_signal("grimoire_opened")
				SignalBus.emit_signal("stat_incremented", "grimoire_opened", 1)
		State.DRAGGING:
			print("Drag ended")
			current_state = State.IDLE

func _process(delta: float) -> void:
	if current_state == State.HOLDING:
		hold_time += delta
		hold_progress_bar.global_position = get_global_mouse_position() + PROGRESS_BAR_OFFSET
		hold_progress_bar.value = min(hold_time / MINIMUM_HOLD_TIME * 100, 100)
	elif current_state == State.DRAGGING:
		global_position = get_global_mouse_position() + drag_offset

func _on_hold_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("LMB") and current_state == State.IDLE:
		get_viewport().set_input_as_handled()
		_start_hold()

func _on_hold_timer_timeout() -> void:
	if current_state == State.HOLDING:
		print("Hold completed (", hold_time, "s), starting drag")
		current_state = State.DRAGGING
		hold_progress_bar.visible = false
		SignalBus.emit_signal("stat_incremented", "grimoire_moved", 1)

func _on_hold_area_mouse_exited() -> void:
	if current_state == State.HOLDING:
		print("Mouse exited during hold (", hold_time, "s)")
		_cancel_hold()

func _start_hold() -> void:
	const HOLD_PROGRESS_INITIAL_VALUE := 0
	const HOLD_PROGRESS_MID_VALUE := 50
	const FADE_IN_DELAY_RATIO := 0.1
	const FIRST_TWEEN_RATIO := 0.5 
	const SECOND_TWEEN_RATIO := 0.5 
	
	print("Starting hold")
	current_state = State.HOLDING
	hold_time = 0.0
	drag_offset = global_position - get_global_mouse_position()
	hold_timer.start(MINIMUM_HOLD_TIME)
	hold_progress_bar.value = HOLD_PROGRESS_INITIAL_VALUE
	hold_progress_bar.modulate = Color(1, 1, 1, 0) 
	hold_progress_bar.visible = true

	var tween = create_tween()
	var first_tween_duration = MINIMUM_HOLD_TIME * FIRST_TWEEN_RATIO
	var fade_in_delay = first_tween_duration * FADE_IN_DELAY_RATIO
	tween.tween_property(hold_progress_bar, "value", HOLD_PROGRESS_MID_VALUE, first_tween_duration)

	tween.parallel().tween_property(
		hold_progress_bar, 
		"modulate", 
		Color(1, 1, 1, 1), 
		first_tween_duration
	).set_delay(fade_in_delay)

func _cancel_hold() -> void:
	print("Cancelling hold")
	current_state = State.IDLE
	hold_timer.stop()
	hold_progress_bar.visible = false
