extends Node

# Helper function for starting transitions
#
#	Transitions.Start(transition_scene,
#		func obscured():
#			get_tree().change_scene_to_packed(next_scene),
#		func unobscured():
#			pass)
func Start(transition_scene: PackedScene) -> Transition:
	var transition = transition_scene.instantiate() as Transition

	self.get_tree().root.add_child.call_deferred(transition)

	return transition
