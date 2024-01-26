class_name Enums extends Node

enum Directions{
	UP,
	RIGHT,
	DOWN,
	LEFT
}

static func random_direction(null_prob : int = 0):
	if randi_range(0,100) <= null_prob: return null
	return Directions.values()[randi() % Directions.size()]
