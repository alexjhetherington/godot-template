extends Node3D
class_name NodeLink

@export var link: Node

func _ready():
	if link == null:
		push_warning(self.name + " node_link does not have a link!")
