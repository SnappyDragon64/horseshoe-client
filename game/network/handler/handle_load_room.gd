class_name HandleLoadRoom
extends Handler


func execute(data: Dictionary) -> void:
	var pos := Vector2(data.pos.x, data.pos.y)
	var room: RoomDef = Registries.ROOMS.get_by_id(data.id)
	
	ChatManager.clear_log()
	WorldManager.load_room(room, pos, data.players)
	GameManager.game_loaded.emit()
