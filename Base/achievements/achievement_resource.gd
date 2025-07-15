class_name AchievementResource
extends Resource

@export var id: String = ""
@export var title: String = ""
@export var description: String = ""
@export var trigger_event: String = "" # The event that can unlock this
@export var required_stat: String = "" # Optional stat to check
@export var required_stat_value: int = 1
