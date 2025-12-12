class_name Rooms
extends DataRegistry


var SKI_VILLAGE: RoomData = _register("ski_village")
var SKI_HILL:    RoomData = _register("ski_hill")


func _get_registry_id() -> String:
	return "room"
