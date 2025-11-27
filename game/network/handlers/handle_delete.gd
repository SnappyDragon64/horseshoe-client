class_name HandleDelete
extends Handler


func execute(data: Dictionary) -> void:
	var id: String = data.get("id")
	
	if GameManager.remote_players.has(id):
		GameManager.remote_players[id].queue_free()
		GameManager.remote_players.erase(id)
		print("Player left: ", id)
