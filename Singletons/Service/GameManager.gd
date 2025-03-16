extends Node

func get_resource_by_name(resource_name: String) -> ResourceInterface:
	var base_path = "res://Resources/"
	var full_path = base_path + resource_name + ".tres"
	if ResourceLoader.exists(full_path):
		return load(full_path)
	else:
		push_error("Resource not found: %s" % full_path)
		return null
