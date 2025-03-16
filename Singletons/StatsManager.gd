extends Node

enum Stat {MOOD_VALUE, HUNGER, THIRST, LONELINESS, ENERGY}

const STAT_LIMITS := {
	Stat.MOOD_VALUE: {"min": -100, "max": 100},
	Stat.HUNGER: {"min": 0, "max": 100},
	Stat.THIRST: {"min": 0, "max": 100},
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

# Backing variables for property setters
var _mood_value: int = 0
var _hunger: int = 0
var _thirst: int = 0
var _loneliness: int = 0
var _energy: int = 100
var mood_name: String = "OK"

# Property setters with automatic clamping and logging
@export var mood_value: int = 0:
	get: return _mood_value
	set(value):
		var clamped = clamp(value, STAT_LIMITS[Stat.MOOD_VALUE].min, STAT_LIMITS[Stat.MOOD_VALUE].max)
		if _mood_value != clamped:
			_mood_value = clamped
			update_mood_name()
			print("Mood Value updated to: %d" % _mood_value)

@export var hunger: int = 0:
	get: return _hunger
	set(value):
		var clamped = clamp(value, STAT_LIMITS[Stat.HUNGER].min, STAT_LIMITS[Stat.HUNGER].max)
		if _hunger != clamped:
			_hunger = clamped
			print("Hunger updated to: %d" % _hunger)

@export var thirst: int = 0:
	get: return _thirst
	set(value):
		var clamped = clamp(value, STAT_LIMITS[Stat.THIRST].min, STAT_LIMITS[Stat.THIRST].max)
		if _thirst != clamped:
			_thirst = clamped
			print("Thirst updated to: %d" % _thirst)

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
		Stat.MOOD_VALUE:
			mood_value = value
		Stat.HUNGER:
			hunger = value
		Stat.THIRST:
			thirst = value
		Stat.LONELINESS:
			loneliness = value
		Stat.ENERGY:
			energy = value

func add_to_stat(stat: Stat, value: int) -> void:
	var current = get_stat(stat)
	update_stat(stat, current + value)

func get_stat(stat: Stat) -> int:
	match stat:
		Stat.MOOD_VALUE: return mood_value
		Stat.HUNGER: return hunger
		Stat.THIRST: return thirst
		Stat.LONELINESS: return loneliness
		Stat.ENERGY: return energy
	return 0

func update_mood_name() -> void:
	for mood in MOOD_THRESHOLDS:
		if mood_value >= MOOD_THRESHOLDS[mood]:
			if mood_name != mood:
				mood_name = mood
				print("Mood changed to: %s" % mood_name)
			return

func _ready() -> void:
	update_mood_name()
