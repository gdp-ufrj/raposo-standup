extends Node2D

@export var music : AudioStreamPlayer2D
@export var timer : Timer
@export var beat_time : float = 0.25
@export var beat_time_multiplier : float = 0.6
@export var max_beat_time_multiplier : float = 1.5
@export var beat_time_increment : float = 0.03

signal current_music_tempo(current_tempo : float)

func _on_bubble_play_audio(name):
	var audio = self.get_node(name)
	if audio:
		audio.play()


func _on_bubble_play_music(has_timer : bool = false):
	music.pitch_scale = beat_time_multiplier
	music.play()
	if has_timer:
		timer.start(beat_time / beat_time_multiplier / 2.0)


func _on_bubble_stop_music():
	music.stop()


func _on_bubble_increment_tempo():
	beat_time_multiplier += beat_time_increment
	if beat_time_multiplier > max_beat_time_multiplier:
		beat_time_multiplier = max_beat_time_multiplier
