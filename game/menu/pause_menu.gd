extends Control

@onready var settings_button : Button = %SettingsButton
@onready var main_menu_button : Button = %MainMenuButton
@onready var quit_button : Button = %QuitButton
@onready var resume_button : Button = %UnpauseButton

func _ready():
	enable(false)

	resume_button.pressed.connect(func(): AppState.pause(false))
	settings_button.pressed.connect(settings)
	main_menu_button.pressed.connect(main_menu)
	quit_button.pressed.connect(quit)

func enable(enabled : bool):
	visible = enabled

	if !enabled:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP

func quit():
	get_tree().quit()

func main_menu():
	AppState.main_menu()

func settings():
	enable(false)
	SettingsMenu.enable(true, func(): PauseMenu.enable(true))
