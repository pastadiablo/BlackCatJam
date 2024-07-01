extends Node

static var instance: GameStateManager

var levelStarMap: Dictionary
var requiredStarMap: Dictionary

var totalStars: int:
	get:
		if !levelStarMap: return 0
		var count = 0
		for stars in levelStarMap.values():
			count += stars
		return count

var levelPaths: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	levelPaths = _get_all_file_paths("res://scenes/levels")
	var i = 0
	for path in levelPaths:
		levelStarMap[path] = 0
		requiredStarMap[path] = i*2
		i += 1
	print(levelPaths)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _get_all_file_paths(path: String) -> Array[String]:  
	var file_paths: Array[String] = []  
	var dir = DirAccess.open(path)  
	dir.list_dir_begin()  
	var file_name = dir.get_next()  
	while file_name != "":  
		var file_path = path + "/" + file_name  
		if dir.current_is_dir():  
			file_paths += _get_all_file_paths(file_path)  
		else:  
			file_paths.append(file_path)  
		file_name = dir.get_next()  
	var resource_paths: Array[String] = []
	for resource_path in file_paths:  
		var new_path = resource_path
		if '.tres.remap' in new_path:
			new_path = new_path.trim_suffix('.remap')
		if '.tscn.remap' in new_path:
			new_path = new_path.trim_suffix('.remap')
		resource_paths.append(new_path)
	return resource_paths
