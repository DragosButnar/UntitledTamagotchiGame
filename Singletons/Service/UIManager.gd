extends Node
class_name UIManager

var _scene_history: Array = []
var _current_scene_path: String = ""

func show_screen(new_scene_path: String):
	# If we already have a scene, push it onto the history stack
	if _current_scene_path != "":
		_scene_history.append(_current_scene_path)
	
	# Update current scene
	_current_scene_path = new_scene_path
	
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

func clear_history():
	# In case you want to reset the scene history at some point
	_scene_history.clear()

func exit():
	SaveManager.save_all()
	get_tree().quit(0)

func _ready() -> void:
	_current_scene_path = FilePaths.MAIN_SCREEN_PATH
