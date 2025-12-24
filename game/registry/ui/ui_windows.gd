class_name UIWindows
extends ProxyRegistry


var MAIN_MENU: UIWindowDef = _register("main_menu", "res://game/ui/main_menu/auth_screen.tscn")
var HUD:       UIWindowDef = _register("hud",       "res://game/ui/hud/hud.tscn")
var LOADER:    UIWindowDef = _register("loader",    "res://game/ui/loading/loading_screen.tscn")
var SPINNER:   UIWindowDef = _register("spinner",   "res://game/ui/loading/spinner.tscn")
var POPUP:     UIWindowDef = _register("popup",     "res://game/ui/common/popup.tscn")


func _register(id: String, path: Variant) -> UIWindowDef:
	var entry: UIWindowDef = UIWindowDef.new(path)
	return super._register(id, entry)
