extends Node
var config: ConfigFile


var defaults = {
}

func _ready() -> void:
	initialize_config()
	
func initialize_config() -> void:
	config = ConfigFile.new()
	var err = config.load(FilePaths.CONFIG_PATH)
	
	if err != OK: # File doesn't exist
		set_defaults()
		save_config()
	else:
		merge_defaults()

func set_defaults() -> void:
	for section in defaults:
		for key in defaults[section]:
			config.set_value(section, key, defaults[section][key])

# Add missing keys from defaults to existing config
func merge_defaults() -> void:
	for section in defaults:
		for key in defaults[section]:
			if not config.has_section_key(section, key):
				config.set_value(section, key, defaults[section][key])
	save_config()  # Save merged changes

# Save config to disk
func save_config() -> void:
	var err = config.save(FilePaths.CONFIG_PATH)
	if err != OK:
		push_error("Failed to save config: Error %d" % err)
