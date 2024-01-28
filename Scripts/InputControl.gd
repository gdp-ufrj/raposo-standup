extends AnimatedSprite2D
signal input_pressed(direction)

@onready var anim = $"../Bubble/Emoji"

func _ready():
	self.play("default")

func _process(delta):
	if Input.is_action_just_pressed("RightEmoji"):
		anim.frame = 3
		input_pressed.emit(Enums.Directions.RIGHT)
	if Input.is_action_just_pressed("LeftEmoji"):
		anim.frame = 2
		input_pressed.emit(Enums.Directions.LEFT)
	if Input.is_action_just_pressed("UpEmoji"):
		anim.frame = 1
		input_pressed.emit(Enums.Directions.UP)
	if Input.is_action_just_pressed("DownEmoji"):
		anim.frame = 4
		input_pressed.emit(Enums.Directions.DOWN)
