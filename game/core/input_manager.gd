extends Node


func _unhandled_input(event: InputEvent) -> void:
	if not WorldManager.local_player:
		return

	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		
		if mouse_event.button_index == MouseButton.MOUSE_BUTTON_LEFT and mouse_event.pressed:
			var click_position: Vector2 = mouse_event.global_position
			var offset: Vector2 = get_viewport().get_visible_rect().size / 2.0
			var target_position: Vector2 = click_position - offset
			
			WorldManager.local_player.move_to(target_position)

			var packet := {
				"type": "move",
				"target": { "x": target_position.x, "y": target_position.y }
			}
			NetworkManager.send_packet(packet)
