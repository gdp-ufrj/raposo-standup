extends AnimatedSprite2D

signal score_increased(value)
signal life_lost()

@export var total_emoji : int = 8
@export var min_emoji : int = 3
@export var null_prob : int = 50
@export var beat_time : float = 2
@export var beat_time_multiplier : float = 1
@export var beat_time_increment : float = 0.5
@export var timer : Timer
@export var music : AudioStreamPlayer2D

var direction_queue : Array
var queue_index : int
var input_hit : bool
var time_left
var opposite_command : bool
var bubble_active : bool
var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	beat_time_multiplier -= beat_time_increment
	generate_bubble()
	set_music_tempo(beat_time)
	
func generate_bubble():
	increment_beat_tempo()
	generate_random_sequence()
	queue_index = 0
	bubble_active = false
	print(direction_queue)


func check_direction(direction):
	var current_queue = direction_queue[queue_index]
	if !input_hit and current_queue == direction:
		print("Acertou")
		score_increased.emit(100)
	else:
		print("Errou")
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
		direction_queue[index] = Enums.random_direction()
		set_emoji += 1
	for i in range(total_emoji):
		if(direction_queue[i] != null): continue
		direction_queue[i] = Enums.random_direction(null_prob)


func _on_player_input_pressed(direction):
	if bubble_active:
		check_direction(direction)


func increment_index():
	queue_index += 1
	input_hit = false
	print(queue_index)
	

func increment_beat_tempo():
	beat_time_multiplier += beat_time_increment
	beat_time_multiplier = clamp(beat_time_multiplier, beat_time_multiplier, beat_time*2)
	set_music_tempo(beat_time/beat_time_multiplier)
	

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
		if !bubble_active:
			queue_index = 0
			bubble_active = true
		else:
			generate_bubble()
