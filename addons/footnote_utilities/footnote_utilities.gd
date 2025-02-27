@tool
extends EditorPlugin

const TRANSITIONS_NAME : String = "Transitions"
const SAVE_MANAGER_NAME : String = "SaveManager"
const SETTINGS_MANAGER_NAME : String = "SettingsManager"
const SOUND_MANAGER_NAME : String = "SoundManager"
const TWEEN_MANAGER_NAME : String = "TweenManager"

var sound_library_inspector

func _enter_tree():

	print("Footnote Utilities activated.")

	add_autoload_singleton(TRANSITIONS_NAME,
			"res://addons/footnote_utilities/transitions/transitions.gd")
	add_autoload_singleton(SAVE_MANAGER_NAME,
			"res://addons/footnote_utilities/save_load/save_manager.gd")
	add_autoload_singleton(SETTINGS_MANAGER_NAME,
			"res://addons/footnote_utilities/save_load/settings_manager.gd")
	add_autoload_singleton(SOUND_MANAGER_NAME,
			"res://addons/footnote_utilities/sound_manager/sound_manager.gd")
	add_autoload_singleton(TWEEN_MANAGER_NAME,
			"res://addons/footnote_utilities/tween/tween_manager.gd")

	sound_library_inspector = preload("res://addons/footnote_utilities/sound_manager/inspector/sound_library_inspector.gd").new()
	add_inspector_plugin(sound_library_inspector)


func _exit_tree():
	remove_autoload_singleton(TRANSITIONS_NAME)
	remove_autoload_singleton(SAVE_MANAGER_NAME)
	remove_autoload_singleton(SETTINGS_MANAGER_NAME)
	remove_autoload_singleton(SOUND_MANAGER_NAME)
	remove_autoload_singleton(TWEEN_MANAGER_NAME)

	remove_inspector_plugin(sound_library_inspector)
