class_name FootnotesDir

static func dir_contents(path, files: Array[String]):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				dir_contents(path + "/" + file_name, files)
				#print("Found directory: " + file_name)
			else:
				files.append(path + "/" + file_name)
				#print("Found file: " + file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
