extends Node

var tweens = {}

func tween_property_unique(object: Object, property: NodePath, final_val: Variant, duration: float) -> Tween:
	var tree = get_tree()
	if !tree:
		# game exiting
		return

	var tween = tree.create_tween()
	tween.tween_property(object, property, final_val, duration)

	var key = str(object.get_instance_id()) + str(property)

	if tweens.has(key):
		var prev := tweens[key] as Tween
		if prev:
			prev.kill()

	tweens[key] = tween
	return tween
