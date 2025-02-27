extends Node

var non_spatial_sound_scene : PackedScene = preload("res://addons/footnote_utilities/sound_manager/prototypes/non_spatial_sound.tscn")
var sound_scene_3d : PackedScene = preload("res://addons/footnote_utilities/sound_manager/prototypes/3d_sound.tscn")

var configs_access : Dictionary = {}

func _ready():
	var files : Array[String] = []
	FootnotesDir.dir_contents("res://assets/audio/library", files)

	for file in files:

		if '.tres.remap' in file:
			file = file.trim_suffix('.remap')

		var sound_collection := load(file)
		if sound_collection is SoundLibrary:
			_add_sound_library(sound_collection)
		if sound_collection is SoundFolder:
			_add_sound_folder(sound_collection)

	var all_sounds = "All Sounds:"
	for existing_key in configs_access.keys():
			all_sounds = all_sounds + "\n   " + existing_key
	# print(all_sounds)

func _add_sound_folder(sound_folder : SoundFolder):
	var files : Array[String] = []
	FootnotesDir.dir_contents(sound_folder.path, files)
	for file in files:
		if file.ends_with(".import"):
			continue

		var audio_stream = load(file) as AudioStream
		var sound_config = sound_folder.sound_config.duplicate()
		sound_config.audio_stream = audio_stream

		_add_config_to_dict(file.get_file().trim_suffix(".wav").trim_suffix(".mp3"), sound_config)

func _add_sound_library(sound_library : SoundLibrary):
	for sound_config in sound_library.sound_configs:
		sound_config.bus = sound_library.bus
		_add_config_to_dict(sound_config.audio_stream.resource_path.get_file()
				.trim_suffix(".wav").trim_suffix(".mp3"),
				sound_config)

		for alias in sound_config.aliases.split(",", false):
			_add_config_to_dict(alias, sound_config)


func _add_config_to_dict(key: String, sound_config : SoundConfig):
	if !configs_access.has(key):
		configs_access[key] = [] as Array[SoundConfig]

	var configs_for_this_key := configs_access[key] as Array[SoundConfig]
	if !configs_for_this_key.has(sound_config):
		configs_for_this_key.append(sound_config)


func _get_config(key: String) -> SoundConfig:
	if !configs_access.has(key):
		var error := key + " does not exist in Sound Manager"
		push_error(error)
		return null
	else:
		var configs_for_this_key := configs_access[key] as Array[SoundConfig]
		return configs_for_this_key.pick_random() # Optimised for size 1?


func play(name: String, pitch_random : float = 0, target : Node3D = null):
	var config := _get_config(name)

	if config == null:
		return # Error already handled

	var player
	if target == null:
		player = non_spatial_sound_scene.instantiate() as AudioStreamPlayer

	else:
		player = sound_scene_3d.instantiate() as AudioStreamPlayer3D

		if config.attenuation == SoundConfig.Attenuation.INV:
			player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
		elif config.attenuation == SoundConfig.Attenuation.INV_SQUARE:
			player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_SQUARE_DISTANCE
		elif config.attenuation == SoundConfig.Attenuation.LOG:
			player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_LOGARITHMIC
		elif config.attenuation == SoundConfig.Attenuation.CONSTANT:
			player.attenuation_model = AudioStreamPlayer3D.ATTENUATION_DISABLED

		player.unit_size = config.unit_size
		player.max_db = config.max_vol_for_3d

		var follows := player.get_child(0) as Follows
		follows.target = target

	self.add_child(player)
	player.name = "Sound:" + name
	player.stream = config.audio_stream

	player.pitch_scale = config.pitch
	if pitch_random != 0:
		var random_adjust = ((randf() * 2) - 1) * pitch_random
		player.pitch_scale += random_adjust

	player.volume_db = config.volume_db

	if !config.bus.is_empty():
		player.bus = config.bus

	player.play()

	return player


var _bus_fades = {}
func fade_bus(bus_name : String, target_volume_linear: float, speed: float):
	var bus_indx = AudioServer.get_bus_index(bus_name)

	if bus_indx == -1:
		push_error("Bus does not exist: " + bus_name)
		return

	if _bus_fades.has(bus_indx):
		var prev_tween := _bus_fades[bus_indx] as Tween
		if prev_tween:
			prev_tween.kill()

	var from_linear := db_to_linear(AudioServer.get_bus_volume_db(bus_indx))
	var duration = abs((target_volume_linear - from_linear) / speed)

	var fade_tween = create_tween()

	if !fade_tween:
		#game exiting
		return

	fade_tween.tween_method(_bindable_bus_volume.bind(bus_indx), from_linear, target_volume_linear, duration)
	_bus_fades[bus_indx] = fade_tween

func _bindable_bus_volume(volume_linear :float, bus_idx: int):
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume_linear))
