extends Node

# Save all game data into a structured JSON file
static func save_all() -> void:
	var save_data := {
		"player": _get_player_data(),
		"lacreatura": _get_lacreatura_data()
	}
	
	var file = FileAccess.open(FilePaths.SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))  # Pretty-print with tabs
		file.close()

# Load all game data from the save file
static func load_all() -> void:
	if not FileAccess.file_exists(FilePaths.SAVE_PATH):
		print("No save file found")
		return
	
	var file = FileAccess.open(FilePaths.SAVE_PATH, FileAccess.READ)
	if file:
		var json = JSON.new()
		var parse_result = json.parse(file.get_as_text())
		if parse_result == OK:
			var save_data = json.data
			_load_player_data(save_data.get("player", {}))
			_load_lacreatura_data(save_data.get("lacreatura", {}))
		else:
			print("JSON Parse Error: ", json.get_error_message())
		file.close()

# Player data collection
static func _get_player_data() -> Dictionary:
	return {
		"inventory": Player.check_inventory(),
		"currency": Player.get_currency()
	}

# Creature data collection
static func _get_lacreatura_data() -> Dictionary:
	var stats = StatsManager.get_stats()
	return stats
	

# Player data loading
static func _load_player_data(data: Dictionary) -> void:
	if "inventory" in data:
		Player.load_inventory(data["inventory"])
	if "currency" in data:
		Player.set_currency(data["currency"])

# Creature data loading
static func _load_lacreatura_data(data: Dictionary) -> void:
	if "stats" in data:
		StatsManager.set_stats(data["stats"])
