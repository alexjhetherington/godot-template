extends Node

var save_games: Array[Node]

const SAVE_PATH = "user://savegame.json"

func _ready():
	if !FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var file_parsed : Array[Variant] = JSON.parse_string(file.get_as_text())
	file.close()

	save_games = []
	save_games.resize(file_parsed.size())
	for i in file_parsed.size():
		if file_parsed[i]:
			save_games[i]= FootnotesDict.recursive_dict_to_inst(file_parsed[i])


func save(slot: int, node_data : Node) -> void:
	print("Saving")
	if save_games.size() < slot + 1:
		save_games.resize(slot + 1)

	save_games[slot] = node_data

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var save_games_as_dicts = []
	save_games_as_dicts.resize(save_games.size())
	for i in save_games.size():
		save_games_as_dicts[i] = FootnotesDict.recursive_inst_to_dict(save_games[i])

	var json_string : String = JSON.stringify(save_games_as_dicts, "\t")

	file.store_line(json_string)
