extends Node

func get_resource_by_name(resource_name: String) -> ResourceInterface:
	var base_path = FilePaths.RESOURCE_FOLDER
	var full_path = base_path + resource_name + ".tres"
	if ResourceLoader.exists(full_path):
		return load(full_path)
	else:
		push_error("Resource not found: %s" % full_path)
		return null

func _ready() -> void:
	get_tree().root.get_window().connect("close_requested", _on_window_close_requested)


func _on_window_close_requested():
	_save_data()
	get_tree().root.get_window().queue_free()

func _save_data():
	SaveManager.save_all()
