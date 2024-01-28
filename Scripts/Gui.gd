extends CanvasLayer

@export var score : int = 0
@export var score_value_label : Label
@export var life : int = 10

func _ready():
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
	life -= 1
	if life <= 0:
		game_over()


func game_over():
	print("Perdeu") 
