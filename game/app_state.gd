extends Node

@export var transition_scene: PackedScene

@export var main_menu_scene: PackedScene

@export var main_game_scene: PackedScene

enum {MAIN_MENU, GAME}
var current : int = MAIN_MENU

var console_open : bool = false
var is_paused : bool = false

func main_menu():
	current = MAIN_MENU
	var transition := Transitions.Start(transition_scene)
	transition.obscured.connect(func(): 
		pause(false)
		get_tree().change_scene_to_packed(main_menu_scene)
	)
	
func game():
	current = GAME
	var transition := Transitions.Start(transition_scene)
	transition.obscured.connect(func(): get_tree().change_scene_to_packed(main_game_scene))

func _ready():
	Console.console_opened.connect(on_console_opened)
	Console.console_closed.connect(on_console_closed)

func _process(_delta):
	if Input.is_action_just_pressed("pause") and current == GAME:
		if !console_open:
			pause(!is_paused)

func pause(paused : bool):
	is_paused = paused
	get_tree().paused = is_paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	PauseMenu.enable(paused)

func on_console_opened():
	console_open = true

func on_console_closed():
	console_open = false

	if is_paused:
		get_tree().paused = true # override what console did
