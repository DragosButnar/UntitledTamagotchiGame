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

func use(user) -> void:
	# If `user` is e.g. a Player or a Creature, apply the effect
	if user and user.has_method("update_stat"):
		# Lower hunger, raise mood
		user.update_stat("hunger", -hunger_reduction)
		user.update_stat("mood", mood_boost)

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
