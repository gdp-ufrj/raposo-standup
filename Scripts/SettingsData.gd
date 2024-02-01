extends Node

const SETTINGS_SAVE_PATH : String = "user://SettingsData.save"

var settings_data_dict : Dictionary = {
	"window_resolution_x" = "480",
	"window_resolution_y" = "270",
	"master_volume" = "1.0",
	"music_volume" = "1.0",
	"sfx_volume" = "1.0"
}

func _ready():
	load_data()

func save_data():
	var file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.WRITE)
	file.store_var(settings_data_dict)

func load_data():
	var file = FileAccess.open(SETTINGS_SAVE_PATH, FileAccess.READ)
	if file:
		settings_data_dict = file.get_var()
		print("LOAD!")
		print(settings_data_dict)
		if OS.get_name() != "Web":
			var window_size = Vector2i(int(settings_data_dict["window_resolution_x"]),int(settings_data_dict["window_resolution_y"]))
			DisplayServer.window_set_size(window_size)
			get_window().move_to_center()
		AudioServer.set_bus_volume_db(0, linear_to_db(float(settings_data_dict["master_volume"]))) #Master
		AudioServer.set_bus_volume_db(1, linear_to_db(float(settings_data_dict["music_volume"]))) #Music
		AudioServer.set_bus_volume_db(2, linear_to_db(float(settings_data_dict["sfx_volume"]))) #SFX

func on_resolution_changed(resolution : Vector2i):
	settings_data_dict["window_resolution_x"] = str(resolution.x)
	settings_data_dict["window_resolution_y"] = str(resolution.y)

func on_volume_changed(bus_name : String, value):
	match bus_name:
		"Master":
			settings_data_dict["master_volume"] = str(value)
		"Music":
			settings_data_dict["music_volume"] = str(value)
		"SFX":
			settings_data_dict["sfx_volume"] = str(value)
