extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Confirm"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
