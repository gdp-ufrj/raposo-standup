extends Node2D

@onready var gui : = $GUI 

var is_over : = false
var is_paused : = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if is_over: return
		pause()

func pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	gui.on_pause(is_paused)

func _on_gui_player_lost() -> void:
	is_over = true
