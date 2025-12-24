class_name UIWindows
extends Registry


var MAIN_MENU: UIWindowDef = _register("main_menu", UIWindowDef.new("res://game/ui/main_menu/auth_screen.tscn"))
var HUD: UIWindowDef = _register("hud", UIWindowDef.new("res://game/ui/hud/hud.tscn"))
var LOADER: UIWindowDef = _register("loader", UIWindowDef.new("res://game/ui/loading/loading_screen.tscn"))
var SPINNER: UIWindowDef = _register("spinner", UIWindowDef.new("res://game/ui/loading/spinner.tscn"))
var POPUP: UIWindowDef = _register("popup", UIWindowDef.new("res://game/ui/common/popup.tscn"))
