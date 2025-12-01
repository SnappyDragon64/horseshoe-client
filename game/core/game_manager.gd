extends Node


var scene_auth: PackedScene = preload("res://game/ui/auth_screen/auth_screen.tscn")
var scene_hud: PackedScene = preload("res://game/ui/hud/hud.tscn")
var default_room: Room = Registries.ROOMS.SKI_VILLAGE


func _ready() -> void:
	NetworkManager.connected.connect(_on_connected)
	NetworkManager.packet_received.connect(_on_packet_received)
	NetworkManager.disconnected.connect(_on_disconnected)
	
	AuthManager.login_success.connect(_on_login_success)
	
	if AuthManager.load_session():
		NetworkManager.connect_to_server(AuthManager.current_token)
	else:
		get_tree().change_scene_to_packed.call_deferred(scene_auth)


func _on_login_success() -> void:
	NetworkManager.connect_to_server(AuthManager.current_token)


func _on_connected() -> void:
	print("Connected to server.")
	
	var hud: CanvasLayer = scene_hud.instantiate()
	add_child(hud)
	
	var camera: Camera2D = Camera2D.new()
	add_child(camera)


func _on_packet_received(data: Dictionary) -> void:
	Registries.HANDLERS.process_packet(data)


func _on_disconnected() -> void:
	print("Disconnected from server.")
	AuthManager.clear_session()
	get_tree().change_scene_to_packed(scene_auth)
