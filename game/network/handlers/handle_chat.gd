class_name HandleChat
extends Handler


func execute(data: Dictionary) -> void:
	var id: String = data.get("id")
	var message: String = data.get("message").substr(0, 120)
	
	if GameManager.remote_players.has(id):
		# print("Remote chat: ", id, ": ", message)
		GameManager.remote_players[id].display_message(message)
