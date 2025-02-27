extends Transition
class_name SimpleFade

var fade_out_length : float = 0.2
var obscured_length : float = 0.5
var fade_in_length : float = 0.2

# Called auto when added to scene tree. Adjust for reuse?
func _ready():
	var tween = create_tween()

	tween.tween_property($ColorRect, "color", Color.from_hsv(0, 0, 0, 1), fade_in_length)

	tween.tween_callback(func(): obscured.emit())

	tween.tween_interval(obscured_length)

	tween.tween_callback(func(): started_unobscure.emit())

	tween.tween_property($ColorRect, "color", Color.from_hsv(0, 0, 0, 0), fade_out_length)

	tween.tween_callback(func(): unobscured.emit())

	tween.tween_callback(self.queue_free)
