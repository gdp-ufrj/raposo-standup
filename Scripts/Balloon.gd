class_name Balloon extends AnimatedSprite2D

var direction #Uma Queue
var time_left
var opposite_command : bool
var inverted_queue : bool

func _init(direction, time_left, opposite_command = false, inverted_queue = false):
	self.direction = direction
	self.time_left = time_left
	self.opposite_command = opposite_command
	self.inverted_queue = inverted_queue

func check_direction(direction):
	if self.direction == direction:	#temporário só o balão simples
		return true
	else:
		return false
