# ------------------------------
#  StatsManager.gd
# ------------------------------
extends Node

"""
Re‑written for dynamic mood calculation.

The `mood_value` is no longer set directly from the outside.
Instead it is derived over time from the "quality" of the other
three gameplay stats:

	• Low hunger   (⇣  ≤ 25)
	• Low loneliness (⇣ ≤ 25)
	• High energy  (⇡ ≥ 75)

Each game “tick” we award a score based on how many of the above
conditions are true and convert that score into a small mood delta:

	3 good stats → +2 mood
	2 good stats → +1 mood
	1 good stat  → −1 mood
	0 good stats → −2 mood

The delta is applied once for every tick that passes (both online
		   and offline) and is *clamped* into the classic
		   [‑100, 100] range.
"""

enum Stat { MOOD_VALUE, HUNGER, LONELINESS, ENERGY }

const STAT_KEYS_TO_ENUM := {
	"mood_value": Stat.MOOD_VALUE,
	"hunger":     Stat.HUNGER,
	"loneliness": Stat.LONELINESS,
	"energy":     Stat.ENERGY,
}

const STAT_LIMITS := {
	Stat.MOOD_VALUE:  { "min": -100, "max": 100 },
	Stat.HUNGER:      { "min":    0, "max": 100 },
	Stat.LONELINESS:  { "min":    0, "max": 100 },
	Stat.ENERGY:      { "min":    0, "max": 100 },
}

const MOOD_THRESHOLDS := {
	"Ecstatic":  80,
	"Happy":     60,
	"OK":        40,
	"Neutral":   20,
	"Depressed":  0,
	"Miserable": -20,
	"Awful":     -40,
	"Dire":      -60,
}

const PICK_MOOD_EVERY := 3

############################################################
#                       Backing store                     #
############################################################

var _mood_value  : float =  0
var _hunger      : float =  0
var _loneliness  : float =  0
var _energy      : float =  100

var _mood_name   : String = "Neutral"

var _pick_word_counter :int= 0

############################################################
#                       Properties                         #
############################################################

@export var mood_value : float = 0:
	get: return _mood_value
	set(value):
		_mood_value = clamp(value,
			STAT_LIMITS[Stat.MOOD_VALUE].min,
			STAT_LIMITS[Stat.MOOD_VALUE].max)

@export var hunger : float = 0:
	get: return _hunger
	set(value):
		_hunger = clamp(value,
			STAT_LIMITS[Stat.HUNGER].min,
			STAT_LIMITS[Stat.HUNGER].max)

@export var loneliness : float = 0:
	get: return _loneliness
	set(value):
		_loneliness = clamp(value,
			STAT_LIMITS[Stat.LONELINESS].min,
			STAT_LIMITS[Stat.LONELINESS].max)

@export var energy : float = 100:
	get: return _energy
	set(value):
		_energy = clamp(value,
			STAT_LIMITS[Stat.ENERGY].min,
			STAT_LIMITS[Stat.ENERGY].max)


############################################################
#                     Generic helpers                      #
############################################################

func get_stat(stat: Stat) -> float:
	match stat:
		Stat.MOOD_VALUE: return mood_value
		Stat.HUNGER:     return hunger
		Stat.LONELINESS: return loneliness
		Stat.ENERGY:     return energy
		_:
			return 0


func update_stat(stat: Stat, value: float) -> void:
	match stat:
		Stat.MOOD_VALUE: mood_value  = value
		Stat.HUNGER:     hunger      = value
		Stat.LONELINESS: loneliness  = value
		Stat.ENERGY:     energy      = value


func add_to_stat(stat: Stat, value: float) -> void:
	update_stat(stat, get_stat(stat) + value)


func get_stats() -> Dictionary:
	return {
		"mood_value": mood_value,
		"hunger":     hunger,
		"loneliness": loneliness,
		"energy":     energy,
	}

func set_stats(data: Dictionary) -> void:
	for key in data:
		if STAT_KEYS_TO_ENUM.has(key):
			update_stat(STAT_KEYS_TO_ENUM[key], data[key])
		else:
			push_error("Invalid stat key: %s" % key)

############################################################
#                Dynamic mood computation                  #
############################################################

func adjust_mood(ticks: int = 1) -> void:
	"""
	Update `mood_value` once per game tick based on the *current*
	values of the other stats.  This is called from `TimeManager`
	after the per‑tick stat drift has been applied.
	"""
	var delta_per_tick : int = _compute_mood_delta()

	if delta_per_tick == 0:
		return  # no change for this tick

	add_to_stat(Stat.MOOD_VALUE, delta_per_tick * ticks)
	_update_mood_name()


func _compute_mood_delta() -> int:
	var good := 0
	if hunger     <= 25: good += 1
	if loneliness <= 25: good += 1
	if energy     >= 75: good += 1

	match good:
		3:
			return  2
		2:
			return  1
		1:
			return -1
		_:
			return -2


func _update_mood_name() -> void:
	for mood in MOOD_THRESHOLDS.keys():
		if mood_value >= MOOD_THRESHOLDS[mood]:
			if _mood_name != mood:
				_mood_name = mood
				print("Mood changed to: %s (%.0f)" % [_mood_name, mood_value])
			return


func get_mood_name() -> String:
	return _mood_name


############################################################
#                  Convenience for UI / FX                 #
############################################################

func pick_word() -> String:
	"""
	Every time the function is invoked, we increment an internal
	counter.  When that counter hits a multiple of `PICK_MOOD_EVERY`,
	the function *forces* the current mood name to be returned.  On
	all other calls, it falls back to the previous weighted‑random
	stat‑name behaviour, which focuses on whichever stat is currently
	furthest from its ideal range.
	"""
	_pick_word_counter += 1

	if _pick_word_counter % PICK_MOOD_EVERY == 0:
		return get_mood_name()

	var candidates := []

	const WORD_THRESHOLDS := {
		Stat.HUNGER:     { "threshold": 50, "above": true  },
		Stat.LONELINESS: { "threshold": 50, "above": true  },
		Stat.ENERGY:     { "threshold": 30, "above": false },
	}

	for stat in WORD_THRESHOLDS.keys():
		var cfg       = WORD_THRESHOLDS[stat]
		var current   = get_stat(stat)
		var passes    = current >= cfg.threshold if cfg.above else current <= cfg.threshold
		if passes:
			var weight = current if cfg.above else (STAT_LIMITS[stat].max - current)
			var key    = STAT_KEYS_TO_ENUM.find_key(stat)
			if key:
				candidates.append({ "name": key, "weight": weight })

	if candidates.is_empty():
		return get_mood_name()

	var total_weight = candidates.reduce(func(acc, c): return acc + c.weight, 0.0)
	if total_weight <= 0:
		return candidates.pick_random().name

	var random_value = randf() * total_weight
	var accumulated  := 0.0
	for c in candidates:
		accumulated += c.weight
		if accumulated >= random_value:
			return c.name

	return ""
