class_name HandleLoadRoom
extends Handler


func execute(data: Dictionary) -> void:
	var pos := Vector2(data.pos.x, data.pos.y)
	WorldManager.load_room(data.id, pos, data.players)
