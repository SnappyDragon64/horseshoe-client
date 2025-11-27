class_name HandleSpawn
extends Handler


func execute(data: Dictionary) -> void:
	var pos := Vector2(data.pos.x, data.pos.y)
	WorldManager.spawn_player(data.id, pos)
