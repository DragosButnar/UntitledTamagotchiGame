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
	# --- create folder + empty save file on first run ---
	if not FileAccess.file_exists(FilePaths.SAVE_PATH):
		# 1. create the directory chain if it’s missing
		if not DirAccess.dir_exists_absolute(FilePaths.SAVE_FOLDER_PATH):
			var err := DirAccess.make_dir_recursive_absolute(FilePaths.SAVE_FOLDER_PATH)
			if err != OK:
				push_error("Couldn't create save folder (%s)" % err)
				return

		# 2. create the file itself with an empty JSON object
		var f := FileAccess.open(FilePaths.SAVE_PATH, FileAccess.WRITE)
		if f:
			f.store_string("{}")   # prevents JSON.parse from ever failing
			f.close()
		else:
			push_error("Couldn't create save file!")
			return
	# (FileAccess.WRITE makes a file only if the directory already exists) :contentReference[oaicite:1]{index=1}

	# --- now read the file as usual ---
	var file := FileAccess.open(FilePaths.SAVE_PATH, FileAccess.READ)
	if not file:
		push_error("Couldn't open save file for reading!")
		return

	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK:
		push_error("Save JSON parse error: %s" % json.get_error_message())
		file.close()
		return
	file.close()

	var save_data: Dictionary = json.data
	_load_player_data(save_data.get("PlayerManager", {}))
	_load_lacreatura_data(save_data.get("stats", {}))
	_load_last_logout(save_data.get("last_logout",
				TimeManager.get_current_time()))
	TimeManager.handle_login()


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
