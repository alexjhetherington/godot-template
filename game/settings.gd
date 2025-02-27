extends Node

var mouse_sensitivity: float = 1.0:
	get:
		return mouse_sensitivity
	set(value):
		mouse_sensitivity = value
		SettingsManager.cfg.set_value(SECTION, "mouse_sensitivity", value)
		SettingsManager.persist()

var volume: float = 1.0:
	get:
		return volume
	set(value):
		volume = value
		SettingsManager.cfg.set_value(SECTION, "volume", value)
		SettingsManager.persist()

		AudioServer.set_bus_volume_db(0, linear_to_db(value))

# 0 windowed
# 3 borderless full screen
# 4 exclusive full screen
var window_mode: int = 2:
	get:
		return window_mode
	set(value):
		window_mode = value
		SettingsManager.cfg.set_value(SECTION, "window_mode", value)
		SettingsManager.persist()

		var to_enum : DisplayServer.WindowMode
		if window_mode > 0:
			to_enum = (window_mode + 2) as DisplayServer.WindowMode
		else:
			to_enum = 0 as DisplayServer.WindowMode

		DisplayServer.window_set_mode.call_deferred(to_enum)

var resolution_scale: float = 1:
	get:
		return resolution_scale
	set(value):
		resolution_scale = value
		SettingsManager.cfg.set_value(SECTION, "resolution_scale", value)
		SettingsManager.persist()

		get_viewport().scaling_3d_scale = resolution_scale

var vsync : bool = true:
	get:
		return vsync
	set(value):
		vsync = value
		SettingsManager.cfg.set_value(SECTION, "vsync", value)
		SettingsManager.persist()
		
		if !vsync:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

var max_fps : int = 0:
	get:
		return max_fps
	set(value):
		max_fps = value
		SettingsManager.cfg.set_value(SECTION, "max_fps", value)
		SettingsManager.persist()

		Engine.max_fps = max_fps

const SECTION : String = "Settings"
func _ready():
	for property_dict in get_property_list():
		if property_dict["usage"] == 4096:
			var property_name := property_dict["name"] as String

			# Initialise properties from file -> config in memory -> this class
			if SettingsManager.cfg.has_section_key(SECTION, property_name):
				set(property_name, SettingsManager.cfg.get_value(SECTION, property_name))
			# Or put default property from this class -> config in memory
			else:
				SettingsManager.cfg.set_value(SECTION, property_name, get(property_name))
				# Trigger setter :) - it also persists
				set(property_name, get(property_name))

	# Persist from this class -> config in memory -> properties from file
	# SettingsManager.persist()
