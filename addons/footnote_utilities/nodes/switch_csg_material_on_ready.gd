extends CSGPrimitive3D

@export var to_material : Material

func _ready():
	self.material = to_material
