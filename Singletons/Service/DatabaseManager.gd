# DatabaseManager.gd
extends Node

const LESSON_TABLE            := "lesson"
const LESSON_SECTION_TABLE    := "lesson_content"
const ACTIVITY_TABLE          := "activity"
const SHOP_INVENTORY          := "shop"
const DIALOGUE_TABLE          := "dialogue"


const LESSON_SECTION_QUERY :="SELECT * FROM %s WHERE lesson_id = ? ORDER BY \"order\" ASC"

var _database : SQLite

func _ready() -> void:
	_database = SQLite.new()
	_database.path = FilePaths.DATABASE_PATH
	_database.set_foreign_keys(true)
	_database.open_db()


func get_shop_inventory() -> Array[Dictionary]:
	return _database.select_rows(SHOP_INVENTORY, "", ["*"])

func get_dialogue_line(tag : String) -> Array[Dictionary]:
	return _database.select_rows(DIALOGUE_TABLE, "tag = '%s'" % tag, ["line"])

func get_all_activities() -> Array[Dictionary]:
	return _database.select_rows(ACTIVITY_TABLE, "", ["*"])

func get_all_lessons() -> Array[Dictionary]:
	return _database.select_rows(LESSON_TABLE, "", ["*"])

func get_lesson_sections(lesson_id : int) -> Array[Dictionary]:
	var sql := LESSON_SECTION_QUERY % LESSON_SECTION_TABLE
	_database.query_with_bindings(sql, [lesson_id])
	return _database.query_result   

func _exit_tree() -> void:
	_database.close_db()
