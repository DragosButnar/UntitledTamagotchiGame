extends Node


# Basic properties
static var currency: int
static var inventory: Dictionary[String, int]

# Called when the node enters the scene tree for the first time
func _ready():
	return

# Add currency to the player
static func add_currency(amount: int):
	currency += amount
	print("Player currency updated: ", currency, "\n")

# Subtract currency if possible. Returns true on success, false if not enough.
static func remove_currency(amount: int) -> bool:
	if Utilities.is_infinite_money_toggled():
		return true
	if currency >= amount:
		currency -= amount
		print("Player currency updated:", currency)
		return true
	else:
		print("Not enough currency. Current:", currency, "Requested:", amount)
		return false

# Adds a specified amount of a given resource to the inventory
static func add_item(resource_name: String, amount: int = 1):
	if resource_name in inventory:
		inventory[resource_name] += amount
	else:
		inventory[resource_name] = amount
	print("Inventory updated:", inventory)

# Removes a specified amount of a given resource (if possible)
static func remove_item(resource_name: String, amount: int = 1) -> bool:
	if resource_name in inventory and inventory[resource_name] >= amount:
		inventory[resource_name] -= amount
		if inventory[resource_name] <= 0:
			inventory.erase(resource_name)  # remove it completely if zero
		print("Inventory updated:", inventory)
		return true
	else:
		print("Cannot remove item:", resource_name, "Not enough in inventory or doesn't exist.")
		return false

# Example use_item method, which might reduce the inventory and trigger effect logic
static func use_item(resource_name: String):
	if remove_item(resource_name, 1):
		print("Used one", resource_name)
	else:
		print("Failed to use item:", resource_name)
		
static func check_inventory_for_resource(resource_name: String = "") -> int:
		var val = inventory.get(resource_name)
		return val if val != null else 0
	
static func check_inventory() -> Dictionary[String, int]:
	return inventory
	
static func get_currency() -> int:
	return currency
	
static func set_currency(value: int) -> void:
	currency = value
	
static func load_inventory(items: Dictionary):
	for key in items.keys():
		add_item(key, int(items[key]))
