extends Node

static func save_all() -> void:
	_save_inventory()

static func _save_inventory() -> void:
	var file = FileAccess.open(FilePaths.SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(Player.check_inventory(), "\t"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
