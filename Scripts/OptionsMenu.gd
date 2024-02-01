extends Control

@onready var resolution_button = $VBoxContainer/Resolution/OptionButton as OptionButton
@onready var back_menu = $Button as Button

const RESOLUTION_DICTIONARY : Dictionary = {
	"480 x 270" : Vector2i(480, 270),
	"960 x 540" : Vector2i(960, 540),
	"1440 x 810" : Vector2i(1440, 810)
}

func _ready():
	add_resolution_items()
	resolution_button.item_selected.connect(on_resolution_selected)

func add_resolution_items():
	for resolution_option in RESOLUTION_DICTIONARY:
		resolution_button.add_item(resolution_option)

func on_resolution_selected(index : int) -> void:
	var window_size = RESOLUTION_DICTIONARY.values()[index]
	DisplayServer.window_set_size(window_size)
	get_window().move_to_center()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
