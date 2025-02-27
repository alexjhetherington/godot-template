class_name FootnotesDict

static func recursive_inst_to_dict(inst):
	var dict := inst_to_dict(inst)

	for key in dict.keys():
		var value = dict[key]
		if typeof(value) == TYPE_OBJECT:
			dict[key] = recursive_inst_to_dict(inst)
		elif typeof(value) == TYPE_DICTIONARY:
			var deep_copy_dict := {}
			dict[key] = deep_copy_dict
			for nested_key in value.keys():
				var typeof = typeof(value[nested_key])
				if (typeof == TYPE_ARRAY
						or typeof == TYPE_OBJECT
						or typeof == TYPE_DICTIONARY):
					deep_copy_dict[nested_key] = recursive_inst_to_dict(value[nested_key])
				else:
					deep_copy_dict[nested_key] = _handle_single_type(value[nested_key])
		elif typeof(value) == TYPE_ARRAY:
			var deep_copy_array := []
			deep_copy_array.resize(value.size())
			dict[key] = deep_copy_array
			for i in value:
				var typeof = typeof(value[i])
				if (typeof == TYPE_ARRAY
						or typeof == TYPE_OBJECT
						or typeof == TYPE_DICTIONARY):
					deep_copy_array[i] = recursive_inst_to_dict(value[i])
				else:
					deep_copy_array[i] = _handle_single_type(value[i])
		else:
			dict[key] = _handle_single_type(dict[key])

	return dict

# GODOT BUG (maybe not technically, but imo it should be)
# Some types are not handled very well when stringified,
# So in this class we pre-empt turning them into strings
static func _handle_single_type(value):
	if typeof(value) == TYPE_VECTOR3:
			return var_to_str(value)

	return value

static func recursive_dict_to_inst(dict):
	var is_node := false

	for key in dict.keys():
		var value = dict[key]
		if key == "@path":
			is_node = true

		if typeof(value) == TYPE_DICTIONARY:
			dict[key] = recursive_dict_to_inst(value)
		elif typeof(value) == TYPE_ARRAY:
			for i in value:
				dict[key][i] = recursive_dict_to_inst(value)
		elif typeof(value) == TYPE_STRING:
			# See _handle_single_type where
			# we may have transformed a var into a string
			var as_var = str_to_var(value)
			if as_var != null:
				dict[key] = as_var

	if is_node:
		return dict_to_inst(dict)
	else:
		return dict
