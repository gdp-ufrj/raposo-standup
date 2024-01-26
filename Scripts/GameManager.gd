extends Node2D

@export var total_emoji : int = 8
@export var min_emoji : int = 3
@export var null_prob : int = 50

var current_balloon : Balloon
var random = RandomNumberGenerator.new()
var sequence : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	random.randomize()
	for i in range(100):
		generate_random_sequence()
		print(sequence)

func _process(delta):
	pass
	
func generate_random_sequence():
	sequence = []
	var set_emoji : int = 0
	for i in range(total_emoji):
		sequence.append(null)
	while set_emoji < min_emoji:
		var index : int = randi_range(0, total_emoji - 1)
		if(sequence[index] != null): continue
		sequence[index] = Enums.random_direction()
		set_emoji += 1
	for i in range(total_emoji):
		if(sequence[i] != null): continue
		sequence[i] = Enums.random_direction(null_prob)

func generate_random_balloon():
	var direction_queue : Array[Enums.Directions] = []
	if random_bool(80) : #Decide se vai ser uma sequência com um ou mais elementos
		direction_queue.append(Enums.random_direction())
	else:	#Múltipla
		for i in range(3):
			direction_queue.append(Enums.random_direction())
	random.randomize()
	var time_left = random.randi_range(3, 8)
	var opposite_command = random_bool(25)	 #Talvez mudar a porcentagem durante o jogo
	create_balloon(direction_queue, time_left, opposite_command)

func create_balloon(direction_queue, time_left, opposite_command):
	current_balloon = Balloon.new(direction_queue, time_left, self._on_balloon_blew_up, opposite_command)
	print(current_balloon.direction_queue)

func _on_player_input_pressed(direction):
	if current_balloon :
		current_balloon.check_direction(direction)

func _on_balloon_blew_up(is_player_hit):
	if is_player_hit:
		print("Acertou")
	else:
		print("Errou")
	generate_random_balloon()

func random_bool(percentage:int):
	return random.randi_range(0, 100) <= percentage
