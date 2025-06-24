extends Node

var current_line: String = ""


func pick_dialogue_line(tag: String="") -> void:
	var mood :=  StatsManager.pick_word()
	var lines = DatabaseManager.get_dialogue_line(tag if tag != "" else mood)
	current_line = lines.pick_random()["line"]
	

func get_current_dialogue_line(tag: String="") -> String:
	pick_dialogue_line(tag)
	return current_line
