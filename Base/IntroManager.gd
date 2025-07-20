extends Node

@onready var mentor: Node2D = %Mentor

func _ready() -> void:
	mentor.scripted_dialogue_finished.connect(_on_mentor_intro_finished)
	await get_tree().create_timer(1.0).timeout
	await mentor.intro_sequence()
	await mentor.tutorial(false)
	mentor.show_up()

func _on_mentor_intro_finished() -> void:
	print("Intro dialogue is complete, mentor will now behave randomly.")
