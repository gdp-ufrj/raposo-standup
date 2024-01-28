extends Node

var run_score : int
var high_score : int

func _ready():
	high_score = load_data()

func save_data(content):
	var file = FileAccess.open("user://score_data.dat", FileAccess.WRITE)
	file.store_64(content)

func load_data():
	var file = FileAccess.open("user://score_data.dat", FileAccess.READ)
	if file:
		return file.get_64()
	return 0

func update_high_score():
	if run_score > high_score: high_score = run_score
	save_data(high_score)

func reset_run_score():
	run_score = 0
