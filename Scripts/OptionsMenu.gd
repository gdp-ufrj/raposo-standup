extends Control

@onready var resolution_button = $VBoxContainer/Resolution/OptionButton as OptionButton

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
	var screen_size = DisplayServer.screen_get_size()  #pega o tamanho do monitor onde está a janela do jogo
	var screen_position = DisplayServer.screen_get_position()
	#var screen_center = Vector2(screen_size.x / 2 - window_size.x / 2, screen_size.y / 2 - window_size.y / 2)
	var screen_center = Vector2(0, 0)	
	DisplayServer.window_set_size(window_size)
	#DisplayServer.window_set_position(screen_center)
