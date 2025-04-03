extends Node

var player_can_lose_money: bool = true

func get_resource_by_name(resource_name: String) -> ResourceInterface:
	var base_path = FilePaths.RESOURCE_FOLDER
	var full_path = base_path + resource_name + ".tres"
	if ResourceLoader.exists(full_path):
		return load(full_path)
	else:
		push_error("Resource not found: %s" % full_path)
		return null

func _ready() -> void:
	_load_data()
	get_tree().auto_accept_quit = false

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_on_window_close_requested()

func _on_window_close_requested() -> void:
	_save_data()
	get_tree().quit(0)

func _save_data() -> void:
	SaveManager.save_all()
	
func _load_data() -> void:
	SaveManager.load_all()

func is_infinite_money_toggled() -> bool:
	return !player_can_lose_money

func toggle_infinite_money() -> void:
	player_can_lose_money = !player_can_lose_money
	print("Infinite money: " + str(is_infinite_money_toggled()))
