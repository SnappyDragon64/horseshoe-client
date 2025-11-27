class_name HandleDelete
extends Handler


func execute(data: Dictionary) -> void:
	var id: String = data.get("id")
	WorldManager.remove_player(id)
