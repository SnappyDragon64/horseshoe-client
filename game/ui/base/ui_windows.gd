class_name UIWindows
extends Registry


var MAIN_MENU: UIWindowEntry = _register("main_menu", "res://game/ui/main_menu/auth_screen.tscn")
var HUD:       UIWindowEntry = _register("hud",       "res://game/ui/hud/hud.tscn")
var LOADER:    UIWindowEntry = _register("loader",    "res://game/ui/loading/loading_screen.tscn")
var SPINNER:   UIWindowEntry = _register("spinner",   "res://game/ui/loading/spinner.tscn")


func _register(id: String, path: Variant) -> UIWindowEntry:
	var entry: UIWindowEntry = UIWindowEntry.new(path)
	return super._register(id, entry)


func flush_cache() -> void:
	for entry: UIWindowEntry in get_values():
		entry.free_cache()


class UIWindowEntry extends RefCounted:
	var _path: String
	var _cached_scene: PackedScene = null
	
	func _init(path: String) -> void:
		_path = path
	
	func cache() -> void:
		_cached_scene = load(_path)
	
	func free_cache() -> void:
		_cached_scene = null
		
	func instantiate(cache_scene: bool = false) -> UIWindow:
		var scene: PackedScene = _cached_scene
		if scene == null:
			scene = load(_path)
		
		var instance: Node = scene.instantiate()
		
		if not instance is UIWindow:
			assert(false, "UIWindowEntry.instantiate() failed: %s is not a UIWindow" % [_path])
			return null
		
		instance = instance as UIWindow
		instance.entry = self
		
		if cache_scene:
			_cached_scene = scene
		
		return instance
