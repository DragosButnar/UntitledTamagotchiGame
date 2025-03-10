extends EntertainmentResource
class_name Book

"""
Book.gd

A specialized entertainment item representing a book.  
It might boost mood a little bit, reduce loneliness, 
and optionally increase knowledge or some other stat.
"""


@export var knowledge_gain: int

func get_resource_name() -> String:
	return item_name

func use(user) -> void:
	# We'll call 'update_stat' on the user, as in the parent class,
	# plus an optional "knowledge" stat for a Book.
	if user and user.has_method("update_stat"):
		user.update_stat("mood", mood_boost)
		user.update_stat("loneliness", -loneliness_reduction)
		# Extra effect for reading a book:
		user.update_stat("knowledge", knowledge_gain)

func get_stats() -> Dictionary:
	# Inherit the parent's stats and add 'knowledge_gain'
	var base_stats = {
		"item_name": item_name,
		"mood_boost": mood_boost,
		"loneliness_reduction": loneliness_reduction,
		"knowledge_gain": knowledge_gain
	}
	return base_stats

func get_boosts() -> Dictionary:
	# Summarize the direct effects
	return {
		"mood": mood_boost,
		"loneliness": -loneliness_reduction,
		"knowledge": knowledge_gain
	}
	
func get_type() -> String:
	return "Book"
