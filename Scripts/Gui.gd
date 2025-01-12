extends CanvasLayer

signal player_lost()

@export var diff_array : Array[int]
@export var score_label : Label
@export var misses : int = 0
@export var max_misses : int = 40
@export var misses_bar : TextureProgressBar

@onready var paused_mask : = $Control/PausedMask

func _ready():
	misses_bar.max_value = max_misses
	paused_mask.visible = false
	update_label()


func update_label():
	score_label.text = str(PlayerScore.run_score)


func _on_bubble_score_increased(diff):
	PlayerScore.run_score += _check_diff_score(diff)
	update_label()

func _check_diff_score(diff : float):
	if diff < diff_array[0]: return 100
	if diff < diff_array[1]: return 50
	if diff < diff_array[2]: return 25
	return 0

func _on_bubble_life_lost():
	misses += 1
	misses_bar.value = misses
	if misses >= max_misses:
		game_over()


func game_over():
	PlayerScore.update_high_score()
	player_lost.emit()


func on_pause(is_paused : bool) -> void :
	paused_mask.visible = is_paused
