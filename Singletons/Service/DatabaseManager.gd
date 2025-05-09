# DatabaseManager.gd
extends Node

const LESSON_TABLE := "lesson"
const LESSON_SECTION_TABLE := "lesson_content"
const ACTIVITY_TABLE := "activity"
const SHOP_INVENTORY := "shop"

var _database: SQLite

func _ready() -> void:
	_database = SQLite.new()
	_database.path = FilePaths.DATABASE_PATH
	_database.set_foreign_keys(true)
	_database.open_db()

func select_all_from_table_where(table_name: String, condition: String, params: Array = [], order_by: String = "") -> Array:
	var query_string = "SELECT * FROM %s" % table_name
	if condition != "":
		query_string += ' WHERE %s' % condition
	
	# Add ORDER BY clause if specified (properly escape column name)
	if order_by != "":
		query_string += ' ORDER BY "%s"' % order_by
	
	# Execute safe parameterized query
	if _database.query_with_bindings(query_string, params):
		return _database.get_query_result()
	else:
		push_error("Database query failed: %s" % query_string)
		return []

func _exit_tree() -> void:
	_database.close_db()
