extends Node2D

@export var final_score_label : Label
@export var high_score_label : Label

func _ready():
	get_tree().paused = false
	final_score_label.text = str(PlayerScore.run_score)
	high_score_label.text = str(PlayerScore.high_score)

func _process(delta):
	if Input.is_action_just_pressed("Confirm"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
