extends AnimatedSprite2D
signal input_pressed(direction)

func _ready():
	self.play("default")

func _process(delta):
	if Input.is_action_just_pressed("RightEmoji"):
		input_pressed.emit(Enums.Directions.RIGHT)
	if Input.is_action_just_pressed("LeftEmoji"):
		input_pressed.emit(Enums.Directions.LEFT)
	if Input.is_action_just_pressed("UpEmoji"):
		input_pressed.emit(Enums.Directions.UP)
	if Input.is_action_just_pressed("DownEmoji"):
		input_pressed.emit(Enums.Directions.DOWN)
