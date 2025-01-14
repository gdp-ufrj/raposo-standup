extends AnimatedSprite2D

signal score_increased(value)
signal life_lost()
signal play_audio(name)
signal change_face(animation)
signal play_music(has_timer : bool)
signal stop_music()
signal end_sequence_tutorial()
signal increment_tempo()
signal toggle_player_input()

@export var total_emoji : int = 8 # total number of spots inside a bubble
@export var min_emoji : int = 3 # minimum number of emojis inside a bubble 
@export var null_prob : int = 50 # probability of null position
@export var opposite_prob : int = 25 # probability of opposite emoji
@export var timer : Timer
@export var music : AudioStreamPlayer2D
@export var game_over_panel : Sprite2D

var audience_emojis := [] #Array de Emojis Plateia
var player_emojis := []   #Array de Emojis Jogador

@onready var indicator_path := $"../Time Indicator/PathFollow2D"

var direction_queue : Array
var current_beat : int
var input_hit : bool
var hit_success : int
var time_left
var bubble_active : bool
var random = RandomNumberGenerator.new()
var in_tutorial : bool
var current_tempo : float
var starting_time : float

var last_beat_time : float
var input_time : float

func _ready():
	in_tutorial = true
	PlayerScore.reset_run_score()
	select_emoji_sprites()
	random.randomize()

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


func generate_bubble(sequence : Array = []):
	reset_screen_emojis()
	if sequence.is_empty():
		generate_random_sequence()
	else:
		set_sequence(sequence)
	current_beat = -1
	bubble_active = false
	hit_success = 0
	play_music.emit(true)
	if(direction_queue[0] != null):
		audience_emojis[0].frame = direction_queue[0] + 1
		play_audio.emit("Clap")
	Enums.print_directions(direction_queue)
	increment_index()


func check_direction(direction):
	var current_index : int = get_beat_index(current_beat)
	var current_queue = direction_queue[current_index]
	
	# if current is not null and above 3, 
	# slides down the expected enum from opposite to normal
	if current_queue != null: current_queue = current_queue % (Enums.Directions.size()/2)
	
	if !input_hit:
		player_emojis[current_index].frame = direction + 1
	
	if !input_hit and current_queue == direction:
		hit_success += 1
		var diff : float = calculate_score(Time.get_ticks_msec())
		score_increased.emit(diff)
	else:
		life_lost.emit()
		
	input_hit = true

func calculate_score(beat_time : float) -> float:
	var current_index : int = get_beat_index(current_beat)
	var score : = beat_time - (starting_time + current_tempo * current_index)
	return absf(score)

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

func set_sequence(sequence : Array):
	direction_queue = sequence

func _on_player_input_pressed(direction):
	if bubble_active:
		check_direction(direction)


func increment_index():
	current_beat += 1
	if current_beat % 2 == 0:
		input_hit = false


func reset_time_indicator():
	indicator_path.progress_ratio = 0
	indicator_path.get_node("Sprite").frame = 0


func end_queue():
	stop_music.emit()
	if !bubble_active:
		change_face.emit("Talking")
		reset_time_indicator()
		start_answer()
	else:
		get_feedback()
		indicator_path.get_node("Sprite").frame = 1
		if !in_tutorial:
			increment_tempo.emit()
			generate_bubble()
		else:
			end_sequence_tutorial.emit()

func _on_timer_timeout():	
	if current_beat == total_emoji * 2 - 2:
		toggle_player_input.emit()
	
	if current_beat == total_emoji * 2 - 1:
		end_queue()
		return
		
	
	var last_index : int = get_beat_index(current_beat - 1)
	
	# If going music and half beat and hasnt played
	if bubble_active and current_beat % 2 != 0 and !input_hit:
		# Check if there was a note
		if direction_queue[last_index] != null:
			life_lost.emit()
		else:
			hit_success += 1
		
	increment_index()
	var current_index : = get_beat_index(current_beat)
	
	if current_index < total_emoji and current_beat % 2 == 0:
		if !bubble_active: #Imprime emojis na tela
			if direction_queue[current_index] != null:
				play_audio.emit("Clap")
				audience_emojis[current_index].frame = direction_queue[current_index] + 1
			else:
				audience_emojis[current_index].frame = 0
		else:
			indicator_path.progress_ratio = indicator_path.progress_ratio + (1.0/7) if current_index != 7 else 1

func start_answer():
	current_beat = -1
	bubble_active = true
	starting_time = Time.get_ticks_msec()
	play_music.emit()
	increment_index()


func _on_gui_player_lost():
	timer.stop()
	stop_music.emit()
	bubble_active = false
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


func _on_tutorial_start_game():
	in_tutorial = false
	generate_bubble()


func _on_tutorial_play_sequence(sequence):
	generate_bubble(sequence)


func _on_audios_current_music_tempo(current_tempo: float) -> void:
	self.current_tempo = current_tempo
	
func get_beat_index(beat : int) -> int:
	return floor((beat + 1) / 2)
