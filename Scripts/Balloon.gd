class_name Balloon extends AnimatedSprite2D

signal blew_up(is_player_hit)

var direction_queue : Array #Uma Queue
var time_left
var queue_index : int
var opposite_command : bool
var inverted_queue : bool

func _init(direction_queue : Array, time_left, function_blew_up, opposite_command = false, inverted_queue = false):
	self.direction_queue = direction_queue
	self.time_left = time_left
	self.opposite_command = opposite_command
	self.inverted_queue = inverted_queue
	queue_index = 0
	blew_up.connect(function_blew_up)

func check_direction(direction):
	if direction_queue[queue_index] == direction:
		queue_index += 1
		if direction_queue.size() == queue_index:
			blew_up.emit(true)			
	else:
		blew_up.emit(false)
