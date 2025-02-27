extends Control

@onready var play_button : Button = %PlayButton
@onready var settings_button : Button = %SettingsButton
@onready var quit_button : Button = %QuitButton

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	play_button.pressed.connect(play)
	settings_button.pressed.connect(settings)
	quit_button.pressed.connect(quit)

func play():
	AppState.game()

func settings():
	visible = false
	SettingsMenu.enable(true, set_to_visible)

func set_to_visible():
	visible = true

func quit():
	get_tree().quit()
