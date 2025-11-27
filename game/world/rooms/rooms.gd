class_name Rooms
extends Registry


var SKI_VILLAGE: Room = register("ski_village")
var SKI_HILL:    Room = register("ski_hill")


func register(id: String, variant: Variant = null) -> Room:
	var room: Room = variant if variant else load("res://data/rooms/{0}.tres".format([id]))
	return super.register(id, room)
