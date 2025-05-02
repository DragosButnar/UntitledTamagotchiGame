# PauseManager.gd
extends Node

signal game_paused
signal game_unpaused

var is_paused := false:
	set(value):
		is_paused = value
		get_tree().paused = is_paused
		if is_paused:
			game_paused.emit()
		else:
			game_unpaused.emit()

func toggle_pause():
	is_paused = !is_paused
