@tool
class_name RoomDef
extends Definition


@export var name: String


func _get_path_hint() -> String:
	return "*.tscn"
