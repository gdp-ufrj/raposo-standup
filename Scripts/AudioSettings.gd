extends HBoxContainer

@onready var audio_name_label = $Label as Label
@onready var h_slider = $HSlider as HSlider

@export_enum("Master", "Music", "SFX") var bus_name : String

var bus_index : int = 0

func _ready():
	get_bus_name_by_index()
	set_name_label_text()
	set_slider_value()
	h_slider.value_changed.connect(on_value_changed)

func set_name_label_text():
	audio_name_label.text = str(bus_name)

func get_bus_name_by_index():
	bus_index = AudioServer.get_bus_index(bus_name)

func set_slider_value():
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func on_value_changed(value : float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
