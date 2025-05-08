extends Node
class_name Shop
"""
Shop.gd

Script handling the shop's inventory and buy/sell logic.
"""
var shop_items: Array[ResourceInterface] = []
const SELL_COST_MODIFIER = 0.5

func _ready():
	##TODO: Load data from DB, remove example data
	var apple: ResourceInterface = load("res://Resources/apple.tres")
	var w_horse: ResourceInterface = load("res://Resources/wooden_horse.tres")
	var c_book: ResourceInterface = load("res://Resources/intro_to_c.tres")
	shop_items = [
		apple,
		w_horse,
		c_book
	]

func load_shop_items() -> Array[ResourceInterface]:
	return shop_items

func buy(item_data: ResourceInterface) -> bool:
	"""
	Attempts to buy an item for the player.
	Returns true if purchase succeeded, false otherwise.
	"""
	var cost = item_data.get_cost()
	var name = item_data.get_internal_name()
	
	# Check if player has enough currency
	if PlayerManager.remove_currency(cost):
		PlayerManager.add_item(name, 1)
		return true
	else:
		return false

func sell(item_data: ResourceInterface) -> bool:
	"""
	Optional method to sell an item. 
	"""
	var cost = item_data.get_cost()
	var name = item_data.get_internal_name()
	
	# Check if player has the item
	if PlayerManager.remove_item(name, 1):
		# Give back some money (could be partial or full cost)
		PlayerManager.add_currency(int(cost * SELL_COST_MODIFIER))
		return true
	else:
		return false
