extends AnimatedSprite2D

@export var total_emoji : int = 8
@export var min_emoji : int = 3
@export var null_prob : int = 50

var direction_queue : Array
var queue_index : int
var time_left
var opposite_command : bool
var bubble_active : bool
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	generate_random_sequence()
	bubble_active = true
	print(direction_queue)

func check_direction(direction):
	if direction_queue[queue_index] == direction:
		queue_index += 1
		if direction_queue.size() == queue_index:
			blew_up()
	else:
		blew_up()

func generate_random_sequence():
	direction_queue = []
	var set_emoji : int = 0
	for i in range(total_emoji):
		direction_queue.append(null)
	while set_emoji < min_emoji:
		var index : int = randi_range(0, total_emoji - 1)
		if(direction_queue[index] != null): continue
		direction_queue[index] = Enums.random_direction()
		set_emoji += 1
	for i in range(total_emoji):
		if(direction_queue[i] != null): continue
		direction_queue[i] = Enums.random_direction(null_prob)


func _on_player_input_pressed(direction):
	if bubble_active:
		check_direction(direction)
		
func blew_up():
	pass

func random_bool(percentage:int):
	return random.randi_range(0, 100) <= percentage
