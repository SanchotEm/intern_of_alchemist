extends Node

@onready var mentor: Node2D = %Mentor 


func _ready() -> void:
	mentor.scripted_dialogue_finished.connect(_on_mentor_intro_finished)
	await get_tree().create_timer(1.0).timeout
	mentor.start_intro_sequence()

func _on_mentor_intro_finished() -> void:
	print("Intro dialogue is complete, mentor will now behave randomly.")
