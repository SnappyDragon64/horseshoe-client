class_name HandleConnect
extends Handler


func execute(data: Dictionary) -> void:
	WorldManager.local_player_id = data.id
	print("Connected as: ", WorldManager.local_player_id)
	
	var join_packet: Dictionary = PacketBuilder.create_join_packet(GameManager.default_room, Vector2.ZERO)
	NetworkManager.send_packet(join_packet)
