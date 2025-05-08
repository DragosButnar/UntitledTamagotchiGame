# test_shop_system.gd
extends GutTest

var shop: Shop

func before_each():
	# Reset player state
	PlayerManager.set_currency(0)
	PlayerManager.inventory = {}
	
	# Load the actual resource SCRIPT (not instance)
	var item_script = load("res://Resources/FoodResource.gd")
	
	# Create testable double CLASS
	var DoubledItem = partial_double(item_script)
	
	# Create INSTANCE of doubled class
	var test_item = DoubledItem.new()
	
	# Configure test item (mimic apple.tres properties)
	test_item.internal_name = "apple"
	test_item.cost = 100
	
	# Configure shop with test item
	shop = autofree(Shop.new())
	shop.shop_items = [test_item]
	add_child(shop)

func test_purchase_with_resource():
	PlayerManager.set_currency(100)
	assert_true(shop.buy(shop.shop_items[0]), 
		"Should successfully purchase item")
	assert_eq(PlayerManager.get_currency(), 0,
		"Currency should be deducted fully")
	assert_eq(PlayerManager.check_inventory_for_resource("apple"), 1,
		"Inventory should contain purchased item")
