extends Control

@onready var quitButton = $ButtonsContainer/QuitButton

func _ready():
	if OS.get_name() == "Web":
		quitButton.hide()


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/gameplay.tscn")


func _on_options_button_pressed():
	pass # Replace with function body.


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
