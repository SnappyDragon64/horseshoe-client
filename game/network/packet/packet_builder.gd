class_name PacketBuilder
extends RefCounted


static func create_join_packet(room: RoomData, pos: Vector2) -> Dictionary:
	return {
		"type": "join_room",
		"room": room.id,
		"pos": { "x": pos.x, "y": pos.y }
	}


static func create_move_packet(target: Vector2) -> Dictionary:
	return {
		"type": "move",
		"target": { "x": target.x, "y": target.y }
	}


static func create_chat_packet(message: String) -> Dictionary:
	return {
		"type": "chat",
		"message": message
	}
