class_name HandleSpawn
extends Handler


func execute(data: Dictionary) -> void:
	var pos := Vector2(data.pos.x, data.pos.y)
	GameManager.spawn_remote_player(data.id, pos)
