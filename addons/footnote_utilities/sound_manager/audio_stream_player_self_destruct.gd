extends Node

var cache_parent : Node

func _ready():
	cache_parent = get_parent()

func _process(_delta):
	if !cache_parent.is_playing():
		await get_tree().process_frame # time for finished signal to emit
		cache_parent.queue_free()
