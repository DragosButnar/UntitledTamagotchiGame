extends Resource
class_name ResourceInterface
"""
ResourceBase.gd

Acts as an interface or abstract base class for game resources.
In GDScript, we can't have true interfaces, so we define a base Resource
with placeholder methods. Subclasses must override these methods.
"""

@export var cost: int
@export var texture: Texture2D = preload("res://Assets/placeholder16x16.png")
@export var internal_name : String

func get_internal_name() -> String:
	# Return the internal name of this resource
	return self.internal_name

func get_display_name() -> String:
	printerr("get_name() not implemented in subclass!")
	return "Unknown Resource"

func get_type() -> String:
	# Return a category or type string (e.g. "Food", "Entertainment")
	printerr("get_type() not implemented in subclass!")
	return "Unspecified"

func use() -> void:
	printerr("use() not implemented in subclass!")
	

func get_stats() -> Dictionary:
	# Return any relevant stats (like nutritional value, durability, etc.).
	printerr("get_stats() not implemented in subclass!")
	return {}

func get_boosts() -> Dictionary:
	# Return stat boosts this resource provides, e.g. {"hunger": -10, "mood": +5}
	printerr("get_boosts() not implemented in subclass!")
	return {}

func get_category() -> String:
	# Another way to define categories, if you keep them separate from 'get_type'
	printerr("get_category() not implemented in subclass!")
	return "Uncategorized"
	
func get_texture() -> Texture2D:
	return texture

func get_cost() -> int:
	return cost

func send_use_signal():
	Utilities.resource_used.emit(get_internal_name())
