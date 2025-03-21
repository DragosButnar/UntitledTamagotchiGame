extends Control

"""
MainMenuScene.gd

A simple main menu scene that lets the player choose what part of the game to go to next.
"""

@onready var lc_button = $PanelContainer/VBoxContainer/LaCreaturaButton
@onready var shop_button = $PanelContainer/VBoxContainer/ShopButton
@onready var exit_button = $PanelContainer/VBoxContainer/ExitButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lc_button.pressed.connect(_on_LaCreaturaButton_pressed)
	shop_button.pressed.connect(_on_ShopButton_pressed)
	exit_button.pressed.connect(_on_ExitButton_pressed)

func _on_LaCreaturaButton_pressed():
	UiManager.show_screen(FilePaths.LACREATURA_SCENE_PATH)

func _on_ShopButton_pressed():
	UiManager.show_screen(FilePaths.SHOP_SCENE_PATH)
	
func _on_ExitButton_pressed():
	UiManager.exit()
