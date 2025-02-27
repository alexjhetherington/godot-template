class_name VectorFunctions

static func horz(input : Vector3) -> Vector3:
	return Vector3(input.x, 0, input.z)

static func vert(input : Vector3) -> Vector3:
	return Vector3(0, input.y, 0)
