extends AnimatedSprite2D

signal score_increased(value)
signal life_lost()
signal play_audio(name)
signal change_face(animation)

@export var total_emoji : int = 8 # total number of spots inside a bubble
@export var min_emoji : int = 3 # minimum number of emojis inside a bubble 
@export var null_prob : int = 50 # probability of null position
@export var opposite_prob : int = 25 # probability of opposite emoji
@export var beat_time : float = 0.25
@export var beat_time_multiplier : float = 1
@export var max_beat_time_multiplier : float = 3
@export var beat_time_increment : float = 0.5
@export var timer : Timer
@export var music : AudioStreamPlayer2D
@export var game_over_panel : Sprite2D

var audience_emojis := [] #Array de Emojis Plateia
var player_emojis := []   #Array de Emojis Jogador

@onready var indicator_path := $"../Time Indicator/PathFollow2D"

var direction_queue : Array
var queue_index : int
var input_hit : bool
var hit_success : int
var time_left
var bubble_active : bool
var random = RandomNumberGenerator.new()
var new_time : float

var last_beat_time : float
var input_time : float

func select_emoji_sprites():
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 0")
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 1")
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 2")
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 3")
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 4")
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 5")
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 6")
	audience_emojis.append($"../Bubble Audience/Emojis/Emoji 7")
	
	player_emojis.append($"Emojis/Emoji 0")
	player_emojis.append($"Emojis/Emoji 1")
	player_emojis.append($"Emojis/Emoji 2")
	player_emojis.append($"Emojis/Emoji 3")
	player_emojis.append($"Emojis/Emoji 4")
	player_emojis.append($"Emojis/Emoji 5")
	player_emojis.append($"Emojis/Emoji 6")
	player_emojis.append($"Emojis/Emoji 7")

func reset_screen_emojis():
	for emoji in audience_emojis:
		emoji.frame = 0
	
	for emoji in player_emojis:
		emoji.frame = 0
	
func _ready():
	PlayerScore.reset_run_score()
	select_emoji_sprites()
	new_time = beat_time
	random.randomize()
	generate_bubble()
	
func generate_bubble():
	generate_random_sequence()
	queue_index = -1
	bubble_active = false
	hit_success = 0
	music.play()
	set_music_tempo(new_time)
	Enums.print_directions(direction_queue)
	current_status()
	increment_index()


func check_direction(direction):
	var current_queue = direction_queue[queue_index]
	
	# if current is not null and above 3, 
	# slides down the expected enum from opposite to normal
	if current_queue != null: current_queue = current_queue % (Enums.Directions.size()/2)
	
	if !input_hit:
		player_emojis[queue_index].frame = direction + 1
	
	if !input_hit and current_queue == direction:
		#print("Acertou")
		hit_success += 1
		var diff : float = Time.get_ticks_msec() - last_beat_time
		print(diff)
		score_increased.emit(diff)
	else:
		#print("Errou")
		life_lost.emit()
	input_hit = true


func generate_random_sequence():
	reset_screen_emojis()
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

func reset_time_indicator():
	indicator_path.progress_ratio = 0
	indicator_path.get_node("Sprite").frame = 0

func _on_timer_timeout():
	# loses life if timeout occurs and player did not play
	if bubble_active and (!input_hit and direction_queue[queue_index] != null):
		life_lost.emit()
	
	if queue_index < total_emoji:
		if !bubble_active: #Imprime emojis na tela
			if direction_queue[queue_index] != null:
				audience_emojis[queue_index].frame = direction_queue[queue_index] + 1
				play_audio.emit("Clap")
			else:
				audience_emojis[queue_index].frame = 0
		else:
			indicator_path.progress_ratio = indicator_path.progress_ratio + (1.0/7) if queue_index != 7 else 1
	
	increment_index()
	# controls the back and forth of audience and player 
	if queue_index == total_emoji:
		music.stop()
		if !bubble_active:
			print('Resposta')
			change_face.emit("Talking")
			reset_time_indicator()
			start_answer()
		else:
			print('Pergunta')
			get_feedback()
			indicator_path.get_node("Sprite").frame = 1
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


func _on_gui_player_lost():
	timer.stop()
	game_over_panel.visible = true
	game_over_panel.get_node("AnimationPlayer").play("PopUp")
	game_over_panel.get_node("TransitionTimer").start()
	play_audio.emit("Explosion")


func _on_transition_timer_timeout():
	game_over_panel.visible = false
	get_tree().change_scene_to_file("res://Scenes/score_screen.tscn")


func get_feedback():
	if hit_success >= 5:
		change_face.emit("Happy")
		play_audio.emit("Laughter")
	elif hit_success <= 2:
		change_face.emit("Sad")
		play_audio.emit("Booing")
	else:
		change_face.emit("Normal")
		play_audio.emit("Cricket")
