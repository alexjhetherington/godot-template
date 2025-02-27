extends EditorInspectorPlugin

var search_text_box : LineEdit
var open_sound_configs_button : Button

var sound_library : SoundLibrary

func _can_handle(object):
	if object is SoundLibrary:
		sound_library = object
		return true
	else:
		return false

func _parse_property(object, type, name, hint_type, hint_string, usage_flags, wide):
	# We handle properties of type integer.
	if type == TYPE_ARRAY:
		search_text_box = LineEdit.new()
		search_text_box.placeholder_text = "search"
		add_custom_control(search_text_box)

		open_sound_configs_button = Button.new()
		open_sound_configs_button.text = "Search"
		open_sound_configs_button.pressed.connect(open_sound_configs_array_inspector)

		add_custom_control(open_sound_configs_button)

	return false

func open_sound_configs_array_inspector():

	var desired_closed : Array[int] = []

	if !search_text_box.text.is_empty():
		for index in sound_library.sound_configs.size():
			var config := sound_library.sound_configs[index]
			if !config.audio_stream.resource_path.get_file().to_lower().contains(search_text_box.text.to_lower()):
				desired_closed.append(index)

	# We know the array is the next sibling after the button, which is at index 0
	var sound_config_property_array = open_sound_configs_button.get_parent().get_child(3)
	non_recursive_print_tree(sound_config_property_array, desired_closed)

func non_recursive_print_tree(node : Node, desired_closed : Array[int]):

	var node_stack : Array[Node] = []
	var child_current_stack : Array[int] = []

	node_stack.push_back(node)
	child_current_stack.push_back(0)

	var iterations = 0

	# Something
	while true:
		if node_stack.is_empty():
			break

		var current_node := node_stack.pop_back() as Node
		var current_child := child_current_stack.pop_back()
		var current_child_max = current_node.get_child_count()

		if current_child >= current_child_max:
			##### DO STUFF WITH THIS NODE BEFORE IT IS FINISHED WITH
			if current_node is Button:
				var button = current_node as Button
				if button.text == "SoundConfig":
					var button_for_element_index := child_current_stack[child_current_stack.size() - 4] - 1

					var desired_expanded = true
					if desired_closed.has(button_for_element_index):
						desired_expanded = false

					var is_expanded = false
					if button.get_parent().get_parent().get_child_count() > 1:
						is_expanded = true


					if desired_expanded != is_expanded:
						button.pressed.emit()
			##### END DO STUFF
			continue

		node_stack.push_back(current_node)
		child_current_stack.push_back(current_child + 1)

		node_stack.push_back(current_node.get_child(current_child))
		child_current_stack.push_back(0)

		#var indent = ""
		#for i in node_stack.size() - 2:
		##	indent += "  "
		#print (indent + str(current_child) + ": " + str(current_node.get_child(current_child).name))

