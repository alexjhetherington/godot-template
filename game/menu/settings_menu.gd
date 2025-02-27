extends Control

@onready var return_button : Button = %ReturnButton
@onready var res_scale_slider : Slider = %ResScaleSlider
@onready var volume_slider : Slider = %VolumeSlider
@onready var sensitivity_slider : Slider = %SensitivitySlider
@onready var window_options : OptionButton = %WindowModeOptions
@onready var fps_spinbox : SpinBox = %FpsSpinbox
@onready var vsync_checkbox : CheckBox = %VysncCheckbox

func _ready():
	enable(false, Callable())

	return_button.pressed.connect(_return)
	res_scale_slider.set_value_no_signal(Settings.resolution_scale)
	res_scale_slider.value_changed.connect(func set_resolution_scale(value): Settings.resolution_scale = value)

	volume_slider.set_value_no_signal(Settings.volume)
	volume_slider.value_changed.connect(func set_volume(value): Settings.volume = value)

	sensitivity_slider.set_value_no_signal(Settings.mouse_sensitivity)
	sensitivity_slider.value_changed.connect(func set_mouse_sensitivity(value): Settings.mouse_sensitivity = value)

	vsync_checkbox.set_pressed_no_signal(Settings.vsync)
	vsync_checkbox.toggled.connect(func set_vsync(value): Settings.vsync = value)

	fps_spinbox.set_value_no_signal(Settings.max_fps)
	fps_spinbox.value_changed.connect(func set_max_fps(value): Settings.max_fps = value)

	window_options.add_item("windowed", 0)
	window_options.add_item("borderless", 1)
	window_options.add_item("exclusive", 2)
	var selected = Settings.window_mode
	window_options.selected = Settings.window_mode
	window_options.item_selected.connect(func set_window_mode(value): Settings.window_mode = value)

var _on_return : Callable
func enable(enabled : bool, on_return : Callable):
	_on_return = on_return

	visible = enabled

	if !enabled:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP

func _return():
	_on_return.call()
	enable(false, Callable())
