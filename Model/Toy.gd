extends EntertainmentResource
class_name Toy
"""
ToyResource.gd

A specialized entertainment item representing a toy.  
Likely gives a decent boost to mood and reduces loneliness more than a book.
"""


func get_display_name() -> String:
	return item_name

func use() -> void:
	send_use_signal()
	StatsManager.add_to_stat(StatsManager.Stat.MOOD_VALUE, mood_boost)
	StatsManager.add_to_stat(StatsManager.Stat.LONELINESS, -loneliness_reduction)

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
