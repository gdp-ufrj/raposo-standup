class_name Enums extends Node

enum Directions{
	UP,
	RIGHT,
	DOWN,
	LEFT,
	OPPOSITE_DOWN,
	OPPOSITE_LEFT,
	OPPOSITE_UP,
	OPPOSITE_RIGHT
}

static func random_direction(null_prob : int = 0, opposite_prob : int = 0):
	if randi_range(0,100) <= null_prob: return null
	elif randi_range(0,100) <= opposite_prob : return return_direction()+4
	return return_direction()

static func return_direction():
	return Directions.values()[randi() % Directions.size()/2]
