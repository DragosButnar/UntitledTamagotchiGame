extends Node
class_name UIManager

var _scene_history: Array = []
var _current_scene_path: String = ""

var _cached_data := {}
var _is_data_cached := false

func show_screen(new_scene_path: String, meta_data = null):
	# If we already have a scene, push it onto the history stack
	if _current_scene_path != "":
		_scene_history.append(_current_scene_path)
	
	# Update current scene
	_current_scene_path = new_scene_path
	
	if meta_data != null:
		set_cached_data(meta_data as Dictionary)
	
	# Actually switch to the new scene
	get_tree().change_scene_to_file(new_scene_path)

func go_back():
	# Pop the last scene from the history and go there
	if _scene_history.size() > 0:
		var previous_scene = _scene_history.pop_back()
		_current_scene_path = previous_scene
		get_tree().change_scene_to_file(previous_scene)
	else:
		print("No previous scene in history.")
		# Optionally handle the case where there's nowhere to go back.
		
		
func get_cached_data() -> Dictionary:
	if _is_data_cached:
		var data = _cached_data
		_cached_data = {}
		_is_data_cached = false
		return data
	printerr("Atempting to acces empty cache...")
	return {}

func set_cached_data(meta_data: Dictionary) -> void:
	if _is_data_cached:
		printerr("Atempting to override already cahced data!")
		return
	_cached_data = meta_data
	_is_data_cached = true
	
func is_data_cached() -> bool:
	return _is_data_cached

func clear_history():
	# In case you want to reset the scene history at some point
	_scene_history.clear()

func exit():
	SaveManager.save_all()
	get_tree().quit(0)

func _ready() -> void:
	_current_scene_path = FilePaths.MAIN_SCREEN_PATH
