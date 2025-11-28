class_name Rooms
extends DataRegistry


var SKI_VILLAGE: Room = _register("ski_village")
var SKI_HILL:    Room = _register("ski_hill")


func _get_registry_id() -> String:
	return "rooms"
