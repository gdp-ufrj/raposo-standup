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
	if randi_range(0,99) < null_prob: return null
	if randi_range(0,99) < opposite_prob: return get_direction()+4
	return get_direction()

static func get_direction():
	return Directions.values()[randi() % Directions.size()/2]
