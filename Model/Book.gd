extends EntertainmentResource
class_name Book

"""
Book.gd

A specialized entertainment item representing a book.  
It might boost mood a little bit, reduce loneliness, 
and optionally increase knowledge or some other stat.
"""



func get_display_name() -> String:
	return item_name

func use() -> void:
	send_use_signal()
	StatsManager.add_to_stat(StatsManager.Stat.MOOD_VALUE, mood_boost)
	StatsManager.add_to_stat(StatsManager.Stat.LONELINESS, -loneliness_reduction)

func get_stats() -> Dictionary:
	# Inherit the parent's stats and add 'knowledge_gain'
	var base_stats = {
		"item_name": item_name,
		"mood_boost": mood_boost,
		"loneliness_reduction": loneliness_reduction,
	}
	return base_stats

func get_boosts() -> Dictionary:
	# Summarize the direct effects
	return {
		"mood": mood_boost,
		"loneliness": -loneliness_reduction,
	}
	
func get_type() -> String:
	return "Book"
