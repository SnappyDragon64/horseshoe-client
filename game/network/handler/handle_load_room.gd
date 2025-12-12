class_name HandleLoadRoom
extends Handler


func execute(data: Dictionary) -> void:
	var pos := Vector2(data.pos.x, data.pos.y)
	var room: RoomData = Registries.ROOMS.by_id(data.id)
	
	WorldManager.load_room(room, pos, data.players)
	GameManager.game_loaded.emit()
