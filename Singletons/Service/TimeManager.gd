# ------------------------------
#  TimeManager.gd
# ------------------------------
extends Node

"""
Re‑written so that mood is automatically adjusted every time the
other stats tick.  All existing public behaviour is preserved.
"""

############################################################
#                       Constants                          #
############################################################

const ONLINE_RATES := {
	# per‑second drift while the game is running
	"hunger":      2,
	"loneliness": -1,
	"energy":     -0.3,
}

const OFFLINE_RATES := {
	# per‑second drift while the game is *not* running
	"hunger":      0.5,
	"loneliness":  1,
	"energy":      1,
}

const TICK_LENGTH          := 1.0  # seconds
const STATS_PRINT_INTERVAL := 5.0  # seconds


############################################################
#                      Private state                       #
############################################################

var _tick_timer     : float = 0.0
var _stats_log_timer: float = 0.0
var last_logout_time: int   = 0


############################################################
#                         Engine                           #
############################################################

func _process(delta: float) -> void:
	if Utilities.is_infinite_money_toggled():
		return

	# accumulate delta until we have one or more full ticks
	_tick_timer += delta
	if _tick_timer >= TICK_LENGTH:
		var ticks := int(_tick_timer / TICK_LENGTH)
		_tick_timer -= ticks * TICK_LENGTH
		_apply_rates(ONLINE_RATES, ticks)

	# periodic debug output
	_stats_log_timer += delta
	if _stats_log_timer >= STATS_PRINT_INTERVAL:
		_stats_log_timer -= STATS_PRINT_INTERVAL
		_print_all_stats()


############################################################
#                        Helpers                           #
############################################################

func _apply_rates(rates: Dictionary, ticks: int) -> void:
	"""
	Apply the supplied `rates` for the given number of `ticks`,
	then update mood so that it stays in sync with the *brand‑new*
	stat values.
	"""
	for stat_key in rates.keys():
		var change = rates[stat_key] * ticks
		if change == 0:
			continue

		var stat_enum = StatsManager.STAT_KEYS_TO_ENUM[stat_key]
		StatsManager.add_to_stat(stat_enum, change)

	# now that the "raw" stats are up‑to‑date, recalc mood
	StatsManager.adjust_mood(ticks)


func _print_all_stats() -> void:
	var parts := PackedStringArray()
	for key in StatsManager.STAT_KEYS_TO_ENUM.keys():
		var enum_val  = StatsManager.STAT_KEYS_TO_ENUM[key]
		var value     = StatsManager.get_stat(enum_val)
		parts.append("%s: %.1f" % [key.capitalize(), value])

	print("[Stats] " + ", ".join(parts))


############################################################
#            Save‑/Load‑ & Login/Logout helpers            #
############################################################

func calculate_offline_changes(elapsed_seconds: float) -> void:
	# apply *per‑second* offline drift as whole ticks
	_apply_rates(OFFLINE_RATES, int(elapsed_seconds))


func load_data(data: Dictionary) -> void:
	last_logout_time = data.get("last_logout", get_current_time())
	_print_all_stats()


func set_last_logout_time(time: int) -> void:
	last_logout_time = time


func get_current_time() -> int:
	return Time.get_unix_time_from_system()


func handle_login() -> void:
	var now := get_current_time()
	var elapsed := now - last_logout_time
	if elapsed > 0:
		calculate_offline_changes(elapsed)


func get_logout_time() -> int:
	return get_current_time()
