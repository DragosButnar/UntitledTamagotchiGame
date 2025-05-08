extends Node

const LESSON_TABLE := "lesson"
const LESSON_SECTION_TABLE := "lesson_content"
const SHOP_INVENTORY := "shop"

var _database: SQLite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_database = SQLite.new()
	_database.path = FilePaths.DATABASE_PATH
	_database.set_foreign_keys(true)
	_database.open_db()


# Returns an array of dictionaries with key: string and value: any
func select_all_from_table_where(table_name: String, condition: String) -> Array:
	return _database.select_rows(table_name, condition, ["*"])


func _exit_tree() -> void:
	_database.close_db()
