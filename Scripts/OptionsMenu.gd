extends Control

@onready var resolution_button = $MarginContainer/VBoxContainer/Resolution/OptionButton as OptionButton
@onready var resolution_container = $MarginContainer/VBoxContainer/Resolution
@onready var language_button = $MarginContainer/VBoxContainer/Language/OptionButton as OptionButton
@onready var back_button = $Button

const RESOLUTION_DICTIONARY : Dictionary = {
	"480 x 270" : Vector2i(480, 270),
	"960 x 540" : Vector2i(960, 540),
	"1440 x 810" : Vector2i(1440, 810)
}

const LANGUAGES_DICTIONARY : Dictionary = {
	"Portugues": "pt",
	"English" : "eng"
}

func _ready():
	if OS.get_name() == "Web":
		resolution_container.hide()
		back_button.grab_focus()
	else:
		resolution_button.item_selected.connect(_on_resolution_selected)
		add_resolution_items()
		var window_size = get_window().size
		for i in range(RESOLUTION_DICTIONARY.values().size()):
			if RESOLUTION_DICTIONARY.values()[i] == window_size:
				resolution_button.selected = i
		resolution_button.grab_focus()
		
	language_button.item_selected.connect(_on_language_selected)
	add_language_items()
	for i in range(LANGUAGES_DICTIONARY.values().size()):
			if LANGUAGES_DICTIONARY.values()[i] == SettingsData.get_current_language():
				language_button.selected = i 

func add_resolution_items():
	for resolution_option in RESOLUTION_DICTIONARY:
		resolution_button.add_item(resolution_option)

func add_language_items():
	for language_option in LANGUAGES_DICTIONARY:
		language_button.add_item(language_option)

func _on_resolution_selected(index : int) -> void:
	var window_size = RESOLUTION_DICTIONARY.values()[index]
	DisplayServer.window_set_size(window_size)
	get_window().move_to_center()
	SettingsData.on_resolution_changed(window_size)

func _on_language_selected(index : int) -> void:
	var language = LANGUAGES_DICTIONARY.values()[index]
	SettingsData.on_language_changed(language)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	SettingsData.save_data()

func update_texts():
	$MarginContainer/VBoxContainer/Resolution/Label.text = tr("RESOLUTION")
	$MarginContainer/VBoxContainer/Language/Label.text = tr("LANGUAGE")
