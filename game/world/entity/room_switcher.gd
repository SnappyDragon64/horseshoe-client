class_name RoomSwitcher
extends Area2D


@export var room: RoomData


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		var player: Player = area
		
		if player.is_local:
			var join_packet: Dictionary = PacketBuilder.create_join_packet(room)
			NetworkManager.send_packet(join_packet)
