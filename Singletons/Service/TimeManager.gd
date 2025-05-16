extends Node

# Time-based stat degradation rates (per real-time second)
const STAT_DECAY_RATES := {
	"hunger": 0.02,  # Increases over time
	"thirst": 0.03,   # Increases over time
	"energy": -0.04,  # Decreases over time
	"mood_value": -0.01  # Slowly decreases
}

# Loneliness decay while in-game (per game minute)
const PASSIVE_LONELINESS_DECAY := 1
const IN_GAME_MINUTE_DURATION := 60.0  # Real-world seconds

# Money earning parameters
const MONEY_CHANCE := 0.3  # 30% chance per activity
const MONEY_MIN := 1
const MONEY_MAX := 10

var last_logout_time: float
var _loneliness_timer: float = 0.0

func _process(delta: float) -> void:
	# Handle real-time loneliness decay
	_loneliness_timer += delta
	if _loneliness_timer >= IN_GAME_MINUTE_DURATION:
		update_passive_decay(_loneliness_timer / IN_GAME_MINUTE_DURATION)
		_loneliness_timer = 0.0

func update_passive_decay(minutes_passed: float) -> void:
	var decay_amount = -PASSIVE_LONELINESS_DECAY * minutes_passed
	StatsManager.add_to_stat(StatsManager.Stat.LONELINESS, floori(decay_amount))

func calculate_offline_changes(elapsed_seconds: float) -> void:
	for stat_key in STAT_DECAY_RATES:
		var rate = STAT_DECAY_RATES[stat_key]
		var stat = StatsManager.STAT_KEYS_TO_ENUM[stat_key]
		var change = floori(elapsed_seconds * rate)
		StatsManager.add_to_stat(stat, change)

func handle_login(saved_time: int) -> void:
	last_logout_time = saved_time
	var current_time = Time.get_unix_time_from_system()
	var elapsed_seconds = float(current_time - last_logout_time)
	
	if elapsed_seconds > 0:
		calculate_offline_changes(elapsed_seconds)
		print("Processed offline time: %.1f hours" % (elapsed_seconds / 3600.0))

func get_logout_time() -> int:
	return Time.get_unix_time_from_system()

func try_grant_activity_reward(activity_type: String) -> void:
	if randf() <= MONEY_CHANCE:
		var amount = randi_range(MONEY_MIN, MONEY_MAX)
		PlayerManager.add_currency(amount)
		print("Earned %d coins from %s!" % [amount, activity_type])
	else:
		print("No money earned from %s..." % activity_type)


func load_data(data: Dictionary) -> void:
	last_logout_time = data.get("last_logout", get_current_time())
	

func set_last_logout_time(data: float):
	last_logout_time = data
	
func get_current_time() -> float:
	return Time.get_unix_time_from_system()
