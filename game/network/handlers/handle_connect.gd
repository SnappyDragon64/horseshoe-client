class_name HandleConnect
extends Handler


func execute(data: Dictionary) -> void:
	WorldManager.local_player_id = data.id
	print("Connected as: ", WorldManager.local_player_id)
	
	NetworkManager.send_packet({
		"type": "join_room",
		"room": "debug_room",
		"pos": {"x": 0, "y": 0}
	})
