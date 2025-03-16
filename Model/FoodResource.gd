extends ResourceInterface
class_name FoodResource
"""
FoodResource.gd

Example resource subclass representing a food item.
"""

@export var food_name: String
@export var hunger_reduction: int
@export var mood_boost: int

func get_display_name() -> String:
	return food_name

func use() -> void:
	StatsManager.add_to_stat(StatsManager.Stat.HUNGER, -hunger_reduction)
	StatsManager.add_to_stat(StatsManager.Stat.MOOD_VALUE, mood_boost)

func get_stats() -> Dictionary:
	return {
		"food_name": food_name,
		"hunger_reduction": hunger_reduction,
		"mood_boost": mood_boost
	}

func get_boosts() -> Dictionary:
	# For consistent naming, returns a dictionary of stat changes
	return {"hunger": -hunger_reduction, "mood": mood_boost}

func get_category() -> String:
	return "Food"
