extends Node

var run_score : int
var high_score : int

func update_high_score():
	if run_score > high_score: high_score = run_score

func reset_run_score():
	run_score = 0
