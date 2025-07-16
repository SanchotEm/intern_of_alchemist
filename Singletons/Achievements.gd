## Achievement Autoload - Handles loading and unlocking achievements
extends Node

var achievement_resources: Array[AchievementResource]
var _unlocked: PackedStringArray = []

func _ready() -> void:
	_load_achievement_resources()
	SignalBus.achievement_triggered.connect(_on_achievement_triggered)
	print("Achievements Ready (Loaded: %d)" % achievement_resources.size())

func _load_achievement_resources() -> void:
	var dir = DirAccess.open("res://Base/achievements/")
	if not dir:
		push_warning("Achievements directory not found")
		return

	for file in dir.get_files():
		if file.ends_with(".tres"):
			var achievement = load(dir.get_current_dir().path_join(file))
			if achievement is AchievementResource:
				achievement_resources.append(achievement)

func _on_achievement_triggered(event_id: String) -> void:
	for achievement in achievement_resources:
		if not achievement.id in _unlocked and achievement.trigger_event == event_id:
			if StatTracking.get_stat(achievement.required_stat) >= achievement.required_stat_value:
				unlock_achievement(achievement.id)

func unlock_achievement(achievement_id: String) -> void:
	if achievement_id not in _unlocked:
		_unlocked.append(achievement_id)
		print("Achievement Unlocked: ", achievement_id)
