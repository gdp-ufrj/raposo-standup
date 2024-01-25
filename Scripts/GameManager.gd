extends Node2D
var list_balloons := []

# Called when the node enters the scene tree for the first time.
func _ready():
	create_balloon("Right", 30) # Replace with function body.
	create_balloon("Left", 30)
	create_balloon("Up", 30)
	create_balloon("Down", 30)
	create_balloon("Right", 30)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func create_balloon(direction, time_left, opposite_command = false, inverted_queue = false): #Instancia balão
	var new_balloon = Balloon.new(direction, time_left, opposite_command, inverted_queue)
	list_balloons.append(new_balloon)

func _on_player_input_pressed(direction):
	if list_balloons.size() != 0 :
		var balloon = list_balloons.pop_front()
		if balloon.check_direction(direction):
			print("Acertou")
		else:
			print("Errou")
