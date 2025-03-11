extends Node

###TODO: Create separate scene for stats and export it here

@export var stats: Dictionary[String, int]

func update_stat(stat: String, value: int) -> void:
	###TODO: Change this
	stats[stat] = value
