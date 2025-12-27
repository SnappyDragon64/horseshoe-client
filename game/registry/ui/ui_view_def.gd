@tool
class_name UIViewDef
extends Definition


@export var is_modal := false
@export var close_on_escape := false
@export var hide_previous := false


func _get_path_hint() -> String:
	return "*.tscn"


func as_modal(flag := true) -> UIViewDef:
	var def := self.duplicate()
	def.is_modal = flag
	return def


func closes_on_escape(flag := true) -> UIViewDef:
	var def := self.duplicate()
	def.close_on_escape = flag
	return def


func hides_previous(flag := true) -> UIViewDef:
	var def := self.duplicate()
	def.hide_previous = flag
	return def


func get_scene() -> PackedScene:
	assert(not path.is_empty(), 
		"UIViewDef [%s]: Failed to get scene." % 
		[id if not id.is_empty() else &"UNREGISTERED"]
	)
	return get_resource() as PackedScene
