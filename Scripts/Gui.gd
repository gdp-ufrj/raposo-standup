extends CanvasLayer

signal player_lost()

@export var score_label : Label
@export var misses : int = 0
@export var max_misses : int = 40
@export var misses_bar : TextureProgressBar

func _ready():
	misses_bar.max_value = max_misses
	update_label()


func update_label():
	score_label.text = str(PlayerScore.run_score)


func _on_bubble_score_increased(diff):
	PlayerScore.run_score += _check_diff_score(diff)
	update_label()

func _check_diff_score(diff : float):
	if diff < 50: return 100
	if diff < 100: return 50
	if diff < 200: return 25
	return 0

func _on_bubble_life_lost():
	misses += 1
	misses_bar.value = misses
	if misses >= max_misses:
		game_over()


func game_over():
	PlayerScore.update_high_score()
	player_lost.emit()
