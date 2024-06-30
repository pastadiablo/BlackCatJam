extends Node

enum CatScene {
	Menu,
	Credits,
	Select,
	Game
}

var nextLevel: String

func SwitchToScene(scene: CatScene):
	_deferredSwitch.call_deferred(scene)

func _deferredSwitch(scene: CatScene):
	get_tree().current_scene.free()
	var path = ""
	match scene:
		CatScene.Menu: path = "res://scenes/MainMenu.tscn"
		CatScene.Credits: path = "res://scenes/Credits.tscn"
		CatScene.Select: path = "res://scenes/GUI/LevelSelect.tscn"
		CatScene.Game: path = nextLevel
	var packed_scene: PackedScene = ResourceLoader.load(path)
	var instanced_scene = packed_scene.duplicate().instantiate()
	if scene == CatScene.Game:
		instanced_scene.levelPathKey = path
		var index = GameStateManager.levelPaths.find(path)
		instanced_scene.levelNumber = index
		print(index)
		if !GameStateManager.levelStarMap.keys().has(path):
			GameStateManager.levelStarMap[path] = 0
	get_tree().root.add_child(instanced_scene)
	get_tree().current_scene = instanced_scene
