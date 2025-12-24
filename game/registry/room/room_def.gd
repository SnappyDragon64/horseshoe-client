@tool
class_name RoomDef
extends Definition


@export var name: String


func _get_path_hint() -> String:
	return "*.tscn"


func get_scene() -> PackedScene:
	return get_resource() as PackedScene
