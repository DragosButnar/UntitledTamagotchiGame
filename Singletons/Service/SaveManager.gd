extends Node

# Save all game data into a structured JSON file
static func save_all() -> void:
	var save_data := {
		"PlayerManager": _get_player_data(),
		"stats": _get_lacreatura_data(),
		"last_logout": TimeManager.get_current_time()
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
			_load_player_data(save_data.get("PlayerManager", {}))
			_load_lacreatura_data(save_data.get("stats", {}))
			_load_last_logout(save_data.get("last_logout", TimeManager.get_current_time()))
		else:
			print("JSON Parse Error: ", json.get_error_message())
		file.close()

# PlayerManager data collection
static func _get_player_data() -> Dictionary:
	return {
		"inventory": PlayerManager.check_inventory(),
		"currency": PlayerManager.get_currency()
	}

# Creature data collection
static func _get_lacreatura_data() -> Dictionary:
	var stats = StatsManager.get_stats()
	return stats



# PlayerManager data loading
static func _load_player_data(data: Dictionary) -> void:
	if "inventory" in data:
		PlayerManager.load_inventory(data["inventory"])
	if "currency" in data:
		PlayerManager.set_currency(data["currency"])

# Creature data loading
static func _load_lacreatura_data(data: Dictionary) -> void:
	StatsManager.set_stats(data)
	

static func _load_last_logout(data: float):
	TimeManager.set_last_logout_time(data)
