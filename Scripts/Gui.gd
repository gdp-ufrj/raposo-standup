extends CanvasLayer

@export var score : int = 0
@export var score_value_label : Label
@export var misses : int = 0
@export var max_misses : int = 40
@export var misses_bar : TextureProgressBar

func _ready():
	misses_bar.max_value = max_misses
	update_label()


func update_label():
	score_value_label.text = str(score)


func _on_bubble_score_increased(diff):
	score += _check_diff_score(diff)
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
	print("Perdeu") 
