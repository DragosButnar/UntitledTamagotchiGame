extends Control

@onready var shop_script = $Shop
@onready var items_container = $PanelContainer/VBoxContainer
@onready var back_button = $PanelContainer/BackButton


# Called when the node enters the scene tree for the first time.
func _ready():
	back_button.pressed.connect(_on_BackButton_pressed)
	
	# Load items from the shop script
	var items: Array[ResourceInterface] = shop_script.load_shop_items()

	# For each item, create a row with a Label and a Buy button
	for item_data in items:
		var item_name = item_data.get_resource_name()
		var cost = item_data.get_cost()
		var boost = item_data.get_boosts()
		
		var boost_string = ""
		
		for key in boost:
			boost_string += key + ":" + str(boost[key]) + " "

		# Create label
		var label = Label.new()
		label.text = "%s (Cost: %d)" % [item_name, cost]
		label.text.capitalize()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		items_container.add_child(label)

		# Create buy button
		var buy_button = Button.new()
		buy_button.text = "Buy " + item_name
		buy_button.set_tooltip_text(boost_string)
		# Pass the item data in a group or set a 'metadata' property
		buy_button.set_meta("item_data", item_data)

		# Connect the button to a callback
		buy_button.pressed.connect(_on_BuyButton_pressed.bind(buy_button))
		items_container.add_child(buy_button)


func _on_BackButton_pressed():
	UiManager.go_back()

func _on_BuyButton_pressed(button: Button):
	print("Button pressed")
	# Retrieve the item data from the button's metadata
	var item_data: ResourceInterface = button.get_meta("item_data")

	var success = shop_script.buy(item_data)
	if success:
		# Show a small feedback message
		print("Purchased: ", item_data.get_resource_name())
		# Possibly emit a signal or update UI
	else:
		print("Purchase failed: Not enough currency or other reason.")
