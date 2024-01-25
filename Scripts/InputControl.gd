extends AnimatedSprite2D
signal input_Pressed(direction)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("RightEmoji"):
		input_Pressed.emit("Right")
	if Input.is_action_just_pressed("LeftEmoji"):
		input_Pressed.emit("Left")
	if Input.is_action_just_pressed("UpEmoji"):
		input_Pressed.emit("Up")
	if Input.is_action_just_pressed("DownEmoji"):
		input_Pressed.emit("Down")
