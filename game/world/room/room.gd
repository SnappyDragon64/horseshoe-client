@tool
class_name Room
extends Node2D


@export var data: RoomDef


func _ready() -> void:
	set_y_sort_enabled(true)
	_setup_camera()


func _get_configuration_warnings() -> PackedStringArray:
	return [] if find_children("*", "NavigationRegion2D").size() > 0 else ["Room node requires a NavigationRegion2D child."]


func _setup_camera() -> void:
	var cam := self.find_children("*", "Camera2D")

	if len(cam) > 0:
		return
	
	var camera := Camera2D.new()
	add_child(camera)
