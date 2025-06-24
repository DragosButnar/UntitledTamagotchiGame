# StatsManager.gd
extends Node

enum Stat {MOOD_VALUE, HUNGER, LONELINESS, ENERGY}

const STAT_KEYS_TO_ENUM := {
	"mood_value": Stat.MOOD_VALUE,
	"hunger": Stat.HUNGER,
	"loneliness": Stat.LONELINESS,
	"energy": Stat.ENERGY
}

const STAT_LIMITS := {
	Stat.MOOD_VALUE: {"min": -100, "max": 100},
	Stat.HUNGER: {"min": 0, "max": 100},
	Stat.LONELINESS: {"min": 0, "max": 100},
	Stat.ENERGY: {"min": 0, "max": 100}
}

const MOOD_THRESHOLDS := {
	"Ecstatic": 80,
	"Happy": 60,
	"OK": 40,
	"Neutral": 20,
	"Depressed": 0
}

# "above" means condition passes when value >= threshold
# "above" == false means passes when value <= threshold
const WORD_THRESHOLDS := {
	Stat.HUNGER: {"threshold": 50, "above": true},
	Stat.LONELINESS: {"threshold": 50, "above": true},
	Stat.ENERGY: {"threshold": 30, "above": false}
}

var _mood_value: int
var _hunger: int
var _loneliness: int
var _energy: int
var mood_name: String

@export var mood_value: int = 0:
	get: return _mood_value
	set(value):
		var clamped = clamp(value, STAT_LIMITS[Stat.MOOD_VALUE].min, STAT_LIMITS[Stat.MOOD_VALUE].max)
		if _mood_value != clamped:
			_mood_value = clamped
			update_mood_name()
			print("Mood Value updated to: %d" % _mood_value)

@export var hunger: int = 100:
	get: return _hunger
	set(value):
		var clamped = clamp(value, STAT_LIMITS[Stat.HUNGER].min, STAT_LIMITS[Stat.HUNGER].max)
		if _hunger != clamped:
			_hunger = clamped
			print("Hunger updated to: %d" % _hunger)

@export var loneliness: int = 0:
	get: return _loneliness
	set(value):
		var clamped = clamp(value, STAT_LIMITS[Stat.LONELINESS].min, STAT_LIMITS[Stat.LONELINESS].max)
		if _loneliness != clamped:
			_loneliness = clamped
			print("Loneliness updated to: %d" % _loneliness)

@export var energy: int = 100:
	get: return _energy
	set(value):
		var clamped = clamp(value, STAT_LIMITS[Stat.ENERGY].min, STAT_LIMITS[Stat.ENERGY].max)
		if _energy != clamped:
			_energy = clamped
			print("Energy updated to: %d" % _energy)

func update_stat(stat: Stat, value: int) -> void:
	match stat:
		Stat.MOOD_VALUE: mood_value = value
		Stat.HUNGER: hunger = value
		Stat.LONELINESS: loneliness = value
		Stat.ENERGY: energy = value

func add_to_stat(stat: Stat, value: int) -> void:
	update_stat(stat, get_stat(stat) + value)

func get_stat(stat: Stat) -> int:
	match stat:
		Stat.MOOD_VALUE: return mood_value
		Stat.HUNGER: return hunger
		Stat.LONELINESS: return loneliness
		Stat.ENERGY: return energy
		_: return 0

func get_stats() -> Dictionary:
	return {
		"mood_value": mood_value,
		"hunger": hunger,
		"loneliness": loneliness,
		"energy": energy
	}

func set_stats(data: Dictionary) -> void:
	for key in data:
		if STAT_KEYS_TO_ENUM.has(key):
			update_stat(STAT_KEYS_TO_ENUM[key], data[key])
		else:
			push_error("Invalid stat key: %s" % key)
	update_mood_name()

func update_mood_name() -> void:
	for mood in MOOD_THRESHOLDS:
		if mood_value >= MOOD_THRESHOLDS[mood]:
			if mood_name != mood:
				mood_name = mood
				print("Mood changed to: %s" % mood_name)
			return

func get_mood_name() -> String:
	return mood_name

func pick_word() -> String:
	var candidates := []
	for stat in WORD_THRESHOLDS:
		var config = WORD_THRESHOLDS[stat]
		var current := get_stat(stat)
		var passes = (current >= config.threshold) if config.above else (current <= config.threshold)
		if passes:
			var weight = current if config.above else (STAT_LIMITS[stat].max - current)
			var stat_key = STAT_KEYS_TO_ENUM.find_key(stat)
			if stat_key:
				candidates.append({"name": stat_key, "weight": weight})

	if candidates.is_empty():
		return ""

	var total_weight = candidates.reduce(func(acc, c): return acc + c.weight, 0)
	if total_weight <= 0:
		return candidates.pick_random().name

	var random_value = randf() * total_weight
	var accumulated := 0.0
	for candidate in candidates:
		accumulated += candidate.weight
		if accumulated >= random_value:
			return candidate.name
	return ""
