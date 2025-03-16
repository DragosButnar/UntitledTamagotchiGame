extends ResourceInterface
class_name EntertainmentResource
"""
EntertainmentResource.gd

Represents a resource that entertains a player or creature,
improving mood or reducing loneliness.
"""

@export var item_name: String
@export var mood_boost: int
@export var loneliness_reduction: int

func get_display_name() -> String:
	return item_name

func use() -> void:
	StatsManager.add_to_stat(StatsManager.Stat.MOOD_VALUE, mood_boost)
	StatsManager.add_to_stat(StatsManager.Stat.LONELINESS, -loneliness_reduction)

func get_stats() -> Dictionary:
	# Return any relevant stats for display or saving
	return {
		"item_name": item_name,
		"mood_boost": mood_boost,
		"loneliness_reduction": loneliness_reduction
	}

func get_boosts() -> Dictionary:
	# A standard dictionary summarizing the resource's effect
	return {
		"mood": mood_boost,
		"loneliness": -loneliness_reduction
	}

func get_category() -> String:
	# You might have categories like 'Edible', 'Wearable', 'Consumable', etc.
	return "Entertainment"
