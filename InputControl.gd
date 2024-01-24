extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("RightEmoji"):
		print("Right")
	if Input.is_action_just_pressed("LeftEmoji"):
		print("Left")
	if Input.is_action_just_pressed("UpEmoji"):
		print("Up")
	if Input.is_action_just_pressed("DownEmoji"):
		print("Down")
