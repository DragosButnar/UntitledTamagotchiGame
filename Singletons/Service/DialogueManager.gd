extends Node

var current_line: String = ""


func pick_dialogue_line(tag: String="") -> void:
	var mood :=  StatsManager.pick_word()
	var lines = DatabaseManager.get_dialogue_line(mood)
	current_line = lines.pick_random()["line"]
	

func get_current_dialogue_line() -> String:
	pick_dialogue_line()
	return current_line
