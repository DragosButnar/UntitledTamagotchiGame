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

func get_resource_name() -> String:
	return item_name

func use(user) -> void:
	# Example: If user is a creature or player that has update_stat()
	if user and user.has_method("update_stat"):
		# Increase mood
		user.update_stat("mood", mood_boost)
		# Decrease loneliness
		user.update_stat("loneliness", -loneliness_reduction)

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
