extends Node2D
var current_balloon : Balloon
var random = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_random_balloon()

func _process(delta):
	pass

func generate_random_balloon():
	var direction_queue = []
	if random_bool(80) : #Decide se vai ser uma sequência com um ou mais elementos
		direction_queue.append(random_direction())
	else:	#Múltipla
		for i in range(3):
			direction_queue.append(random_direction())
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

func random_direction():
	random.randomize()
	var random_number = random.randi_range(0, 3)
	match random_number:
		0:
			return "Up"
		1:
			return "Down"
		2:
			return "Right"
		3:
			return "Left"

func random_bool(percentage:int):
	random.randomize()
	return random.randi_range(0, 100) <= percentage
