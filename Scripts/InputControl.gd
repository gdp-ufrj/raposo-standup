extends AnimatedSprite2D
signal input_pressed(direction)

var is_input_enabled : = false

func _ready():
	self.play("default")

func _process(delta):
	if !is_input_enabled: return
	if Input.is_action_just_pressed("RightEmoji"):
		input_pressed.emit(Enums.Directions.RIGHT)
	if Input.is_action_just_pressed("LeftEmoji"):
		input_pressed.emit(Enums.Directions.LEFT)
	if Input.is_action_just_pressed("UpEmoji"):
		input_pressed.emit(Enums.Directions.UP)
	if Input.is_action_just_pressed("DownEmoji"):
		input_pressed.emit(Enums.Directions.DOWN)

func _on_bubble_toggle_player_input() -> void:
	is_input_enabled = !is_input_enabled
