class_name UIWindows
extends Registry


var MAIN_MENU: UIWindowDef = _register("main_menu", "res://game/ui/main_menu/auth_screen.tscn")
var HUD:       UIWindowDef = _register("hud",       "res://game/ui/hud/hud.tscn")
var LOADER:    UIWindowDef = _register("loader",    "res://game/ui/loading/loading_screen.tscn")
var SPINNER:   UIWindowDef = _register("spinner",   "res://game/ui/loading/spinner.tscn")
var POPUP:     UIWindowDef = _register("popup",     "res://game/ui/common/popup.tscn")


func _register(id: String, path: Variant) -> UIWindowDef:
	var entry: UIWindowDef = UIWindowDef.new(path)
	return super._register(id, entry)


func flush_cache() -> void:
	for entry: UIWindowDef in get_values():
		entry.free_cache()


class UIWindowDef extends RefCounted:
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
			assert(false, "UIWindowDef.instantiate() failed: %s is not a UIWindow" % [_path])
			return null
		
		instance = instance as UIWindow
		instance.entry = self
		
		if cache_scene:
			_cached_scene = scene
		
		return instance
