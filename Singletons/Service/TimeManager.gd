# TimeManager.gd
extends Node

# === CONFIGURATION ===
const ONLINE_RATES := {
	"hunger": 2,
	"loneliness": -1,
	"energy": -1,
}

const OFFLINE_RATES := {
	"hunger": 1,
	"loneliness": 1,
	"energy": 2,
}

const TICK_LENGTH := 1.0               # Seconds – how often we apply ONLINE_RATES
const STATS_PRINT_INTERVAL := 10.0     # Seconds – how often we dump *all* stats to the console

# === STATE ===
var _tick_timer: float = 0.0           # Accumulates time until we reach the next tick
var _stats_log_timer: float = 0.0      # Accumulates time until the next full‑stats print
var last_logout_time: int = 0

# === ENGINE CALLBACKS ===
func _process(delta: float) -> void:
	# Handle per‑tick stat changes while the game is running
	_tick_timer += delta
	if _tick_timer >= TICK_LENGTH:
		var ticks := int(_tick_timer / TICK_LENGTH)
		_tick_timer -= ticks * TICK_LENGTH
		_apply_rates(ONLINE_RATES, ticks)

	# Periodically dump every stat for easy debugging/monitoring
	_stats_log_timer += delta
	if _stats_log_timer >= STATS_PRINT_INTERVAL:
		_stats_log_timer -= STATS_PRINT_INTERVAL
		_print_all_stats()

# === INTERNAL HELPERS ===
func _apply_rates(rates: Dictionary, ticks: int) -> void:
	for stat_key in rates.keys():
		var change := int(rates[stat_key] * ticks)
		if change == 0:
			continue
		var stat_enum = StatsManager.STAT_KEYS_TO_ENUM[stat_key]
		StatsManager.add_to_stat(stat_enum, change)
		print("[TimeManager] %s changed by %d" % [stat_key, change])

func _print_all_stats() -> void:
	# Pull the *current* values directly from StatsManager to ensure accuracy.
	var parts: PackedStringArray = []
	for stat_key in StatsManager.STAT_KEYS_TO_ENUM.keys():
		var stat_enum = StatsManager.STAT_KEYS_TO_ENUM[stat_key]
		var value := StatsManager.get_stat(stat_enum)
		parts.append("%s: %s" % [stat_key, str(value)])
	print("[TimeManager] Current stats -> %s" % ", ".join(parts))

# === PUBLIC API ===
func calculate_offline_changes(elapsed_seconds: float) -> void:
	_apply_rates(OFFLINE_RATES, int(elapsed_seconds))

func update_passive_decay(minutes_passed: float) -> void:
	pass

func load_data(data: Dictionary) -> void:
	last_logout_time = data.get("last_logout", get_current_time())
	_print_all_stats()

func set_last_logout_time(time: int) -> void:
	last_logout_time = time

func get_current_time() -> int:
	return Time.get_unix_time_from_system()

func handle_login(saved_time: int) -> void:
	last_logout_time = saved_time
	var now := get_current_time()
	var elapsed := now - last_logout_time
	if elapsed > 0:
		calculate_offline_changes(elapsed)

func get_logout_time() -> int:
	return get_current_time()
