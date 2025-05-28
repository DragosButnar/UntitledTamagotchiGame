extends Node

signal leave_scene(earning_text)

# Money earning parameters
const MONEY_CHANCE := 0.3  # 30% chance per activity
const MONEY_MIN := 1
const MONEY_MAX := 10

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
	
func try_grant_activity_reward() -> String:
	if randf() <= MONEY_CHANCE:
		var amount = randi_range(MONEY_MIN, MONEY_MAX)
		PlayerManager.add_currency(amount)
		return "Earned %d coins!" % amount
	else:
		return "No money earned..."
