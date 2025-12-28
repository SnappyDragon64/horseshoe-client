class_name UIViews
extends Registry

## Registry for [UIViewDef] configurations.
##
## Acts as the central registry for all UI scenes available to the [UIStack].

var MAIN_MENU: UIViewDef = _register("main_menu", UIViewDef.new("res://game/ui/main_menu/auth_screen.tscn"))
var HUD: UIViewDef = _register("hud", UIViewDef.new("res://game/ui/hud/hud.tscn"))
var LOADER: UIViewDef = _register("loader", UIViewDef.new("res://game/ui/loading/loading_screen.tscn"))
var SPINNER: UIViewDef = _register("spinner", UIViewDef.new("res://game/ui/loading/spinner.tscn"))
var POPUP: UIViewDef = _register("popup", UIViewDef.new("res://game/ui/common/popup.tscn"))
