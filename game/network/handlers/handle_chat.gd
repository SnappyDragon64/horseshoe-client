class_name HandleChat
extends Handler


func execute(data: Dictionary) -> void:
	var id: String = data.get("id")
	var message: String = data.get("message").substr(0, 120)
	WorldManager.player_message(id, message)
