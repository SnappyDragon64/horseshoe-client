class_name Rooms
extends DataRegistry


var SKI_VILLAGE: RoomDef = _register("ski_village")
var SKI_HILL:    RoomDef = _register("ski_hill")


func _get_registry_id() -> String:
	return "room"
