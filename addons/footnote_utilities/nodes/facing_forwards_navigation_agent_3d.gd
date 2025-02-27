extends NavigationAgent3D
class_name FacingForwardsNavigationAgent3D

@export var rotation_offset = 0

var _parent : Node3D

func _ready():
	_parent = get_parent()

func move(delta, speed):
	var next_pos = get_next_path_position()
	var movement := next_pos - _parent.global_position as Vector3
	if movement.length() > delta * speed:
		movement = movement.normalized() * delta * speed

	if movement.length() > 0.0001:
		_parent.look_at(_parent.position + VectorFunctions.horz(movement))
		_parent.rotate(Vector3.UP, deg_to_rad(rotation_offset))
	_parent.global_position += movement
