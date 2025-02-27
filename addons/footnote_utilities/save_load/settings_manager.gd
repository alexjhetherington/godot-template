extends Node

var cfg : ConfigFile

const SETTINGS_PATH = "user://settings.cfg"

func _ready():
	cfg = ConfigFile.new()
	var err = cfg.load(SETTINGS_PATH)

	# If the file didn't load, ignore it.
	if err != OK:
		return

func persist():
	cfg.save(SETTINGS_PATH)
