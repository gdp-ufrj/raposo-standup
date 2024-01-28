extends Node

signal start_game()
signal play_sequence(sequence : Array)

var tutorial_sequences : Array[Array]
var current_sequence : int

func _ready():
	_set_tutorial_sequences()
	current_sequence = 0
	if(tutorial_sequences.size() == 0):
		start_game.emit()
		return
	play_sequence.emit(tutorial_sequences[0])
	
func _set_tutorial_sequences():
	var tutorial1 : Array = [
		Enums.Directions.UP, null,
		Enums.Directions.RIGHT, null,
		Enums.Directions.DOWN, null,
		Enums.Directions.LEFT, null
	]
	
	var tutorial2 : Array = [
		Enums.Directions.UP, Enums.Directions.OPPOSITE_DOWN,
		Enums.Directions.RIGHT, Enums.Directions.OPPOSITE_LEFT,
		Enums.Directions.DOWN, Enums.Directions.OPPOSITE_UP,
		Enums.Directions.LEFT, Enums.Directions.OPPOSITE_RIGHT
	]
	
	tutorial_sequences = [tutorial1, tutorial2]


func _on_bubble_end_sequence_tutorial():
	current_sequence += 1
	if tutorial_sequences.size() == current_sequence:
		start_game.emit()
		return
	play_sequence.emit(tutorial_sequences[current_sequence])
