extends EntertainmentResource
class_name Toy
"""
ToyResource.gd

A specialized entertainment item representing a toy.  
Likely gives a decent boost to mood and reduces loneliness more than a book.
"""


func get_resource_name() -> String:
	return item_name

func use(user) -> void:
	# Similar pattern to BookResource, but no extra stats besides mood/loneliness
	if user and user.has_method("update_stat"):
		user.update_stat("mood", mood_boost)
		user.update_stat("loneliness", -loneliness_reduction)

func get_stats() -> Dictionary:
	# Inherit parent's stats logic, but for clarity, we define them here
	return {
		"item_name": item_name,
		"mood_boost": mood_boost,
		"loneliness_reduction": loneliness_reduction
	}

func get_boosts() -> Dictionary:
	return {
		"mood": mood_boost,
		"loneliness": -loneliness_reduction
	}

func get_category() -> String:
	# Still "Entertainment," though you could specialize if desired
	return "Toy"
