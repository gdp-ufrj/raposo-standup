extends CanvasLayer

@export var score : int = 0
@export var score_value_label : Label
@export var life : int = 10

func _ready():
	update_label()


func update_label():
	score_value_label.text = str(score)


func _on_bubble_score_increased(value):
	score += value
	update_label()


func _on_bubble_life_lost():
	life -= 1
	if life <= 0:
		game_over()


func game_over():
	print("Perdeu") 
