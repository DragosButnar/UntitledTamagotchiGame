extends Node

static func save_all() -> void:
	_save_inventory()

static func _save_inventory() -> void:
	var file = FileAccess.open(FilePaths.SAVE_PATH, FileAccess.WRITE)
	print(file)
	if file:
		file.store_string(JSON.stringify("test"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var err = DirAccess.make_dir_recursive_absolute(FilePaths.SAVE_FOLDER_PATH)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
