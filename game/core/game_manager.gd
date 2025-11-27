extends Node


var scene_hud: PackedScene = preload("res://game/ui/hud.tscn")
var default_room: Room = Registries.ROOMS.SKI_VILLAGE


func _ready() -> void:
	NetworkManager.connected.connect(_on_connected)
	NetworkManager.packet_received.connect(_on_packet_received)
	NetworkManager.disconnected.connect(_on_disconnected)


func start_game() -> void:
	NetworkManager.connect_to_server()


func _on_connected() -> void:
	print("Connected to server.")
	
	var hud: CanvasLayer = scene_hud.instantiate()
	add_child(hud)
	
	var camera: Camera2D = Camera2D.new()
	add_child(camera)
	
	var join_packet: Dictionary = {
		"type": "join_room",
		"room": default_room.id,
		"pos": {"x": 0, "y": 0}
	}
	NetworkManager.send_packet(join_packet)


func _on_packet_received(data: Dictionary) -> void:
	Registries.HANDLERS.process_packet(data)


func _on_disconnected() -> void:
	print("Disconnected from server.")
	get_tree().quit()
