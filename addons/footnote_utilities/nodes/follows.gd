extends Node
class_name Follows

@export var target : Node3D

@export var position_offset : Vector3
@export var rotation_offset : Vector3

@onready
var parent : Node3D = get_parent() as Node3D

func _process(_delta):
	if !is_instance_valid(target):
		return

	parent.global_position = target.global_position + position_offset

	var x = deg_to_rad(rotation_offset.x)
	var y = deg_to_rad(rotation_offset.y)
	var z = deg_to_rad(rotation_offset.z)
	parent.global_rotation = target.global_rotation + Vector3(x, y, z)
