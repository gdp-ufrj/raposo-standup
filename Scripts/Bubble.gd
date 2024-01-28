extends AnimatedSprite2D

signal score_increased(value)
signal life_lost()

@export var total_emoji : int = 8 # total number of spots inside a bubble
@export var min_emoji : int = 3 # minimum number of emojis inside a bubble 
@export var null_prob : int = 50 # probability of null position
@export var opposite_prob : int = 25 # probability of opposite emoji
@export var beat_time : float = 2
@export var beat_time_multiplier : float = 1
@export var max_beat_time_multiplier : float = 3
@export var beat_time_increment : float = 0.5
@export var timer : Timer
@export var music : AudioStreamPlayer2D
@export var emoji_squares : Array[Sprite2D]
@export var arrow_sprite : Texture2D
@export var inverse_arrow_sprite : Texture2D
@export var empty_sprite : Texture2D

var direction_queue : Array
var queue_index : int
var input_hit : bool
var time_left
var bubble_active : bool
var random = RandomNumberGenerator.new()
var new_time : float

var last_beat_time : float
var input_time : float

func _ready():
	new_time = beat_time
	random.randomize()
	generate_bubble()
	
func generate_bubble():
	generate_random_sequence()
	queue_index = -1
	bubble_active = false
	music.play()
	set_music_tempo(new_time)
	Enums.print_directions(direction_queue)
	show_emoji_screen()
	current_status()
	increment_index()


func check_direction(direction):
	var current_queue = direction_queue[queue_index]
	
	# if current is not null and above 3, 
	# slides down the expected enum from opposite to normal
	if current_queue != null: current_queue = current_queue % (Enums.Directions.size()/2)
	
	if !input_hit and current_queue == direction:
		#print("Acertou")
		var diff : float = Time.get_ticks_msec() - last_beat_time
		print(diff)
		score_increased.emit(diff)
	else:
		#print("Errou")
		life_lost.emit()
	input_hit = true


func generate_random_sequence():
	direction_queue = []
	var set_emoji : int = 0
	for i in range(total_emoji):
		direction_queue.append(null)
	while set_emoji < min_emoji:
		var index : int = randi_range(0, total_emoji - 1)
		if(direction_queue[index] != null): continue
		direction_queue[index] = Enums.random_direction(0, opposite_prob)
		set_emoji += 1
	for i in range(total_emoji):
		if(direction_queue[i] != null): continue
		direction_queue[i] = Enums.random_direction(null_prob, opposite_prob)


func _on_player_input_pressed(direction):
	if bubble_active:
		check_direction(direction)


func increment_index():
	queue_index += 1
	input_hit = false
	last_beat_time = Time.get_ticks_msec()
	#print(str(queue_index) + " - " + str(last_beat_time))

func increment_beat_tempo():
	beat_time_multiplier += beat_time_increment
	if beat_time_multiplier > max_beat_time_multiplier:
		beat_time_multiplier = max_beat_time_multiplier
	new_time = beat_time/beat_time_multiplier

func set_music_tempo(tempo: float):
	timer.start(tempo)
	music.pitch_scale = beat_time_multiplier


func _on_timer_timeout():
	# loses life if timeout occurs and player did not play
	if bubble_active and (!input_hit and direction_queue[queue_index] != null):
		life_lost.emit()
	
	increment_index()
	
	# controls the back and forth of audience and player 
	if queue_index == total_emoji:
		music.stop()
		if !bubble_active:
			print('Resposta')
			start_answer()
		else:
			print('Pergunta')
			increment_beat_tempo()
			generate_bubble()

func current_status():
	return
	print('Pitch: ' + str(music.pitch_scale))
	print('Timer: ' + str(timer.time_left))
	print('Beat time: ' + str(new_time))

func start_answer():
	queue_index = -1
	bubble_active = true
	music.play()
	set_music_tempo(new_time)
	current_status()
	increment_index()

func show_emoji_screen():
	for i in range(total_emoji):
		var direction = direction_queue[i]
		if direction == null:
			emoji_squares[i].texture = empty_sprite
			emoji_squares[i].rotation_degrees = 0
			continue
		if direction < 4:
			emoji_squares[i].texture = arrow_sprite
		else:
			emoji_squares[i].texture = inverse_arrow_sprite
		match direction % 4:
			Enums.Directions.UP:
				emoji_squares[i].rotation_degrees = -90
			Enums.Directions.RIGHT:
				emoji_squares[i].rotation_degrees = 0
			Enums.Directions.DOWN:
				emoji_squares[i].rotation_degrees = 90
			Enums.Directions.LEFT:
				emoji_squares[i].rotation_degrees = 180
			
