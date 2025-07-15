## Stat Tracking Autoload
# Track various pieces of data we may later use for fun
extends Node

# Add the new stat here
var _stats: Dictionary = {
	"items_picked_up": 0,
}
func _ready() -> void:
	SignalBus.stat_incremented.connect(increment_stat)

# This function is the single source of truth for changing a stat.
# It can be called directly or by the signal.
func increment_stat(stat_name: String, value: int = 1) -> void:
	if _stats.has(stat_name):
		_stats[stat_name] += value
		SignalBus.achievement_triggered.emit(stat_name)
		print("Stat updated %s is now %s" % [stat_name, _stats[stat_name]])
	else:
		push_warning("Attempted to increment uninitialized stat '%s'" % stat_name)

func get_stat(stat_name: String) -> int:
	return _stats.get(stat_name, 0)
