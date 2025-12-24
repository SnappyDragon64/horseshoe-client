extends Node


signal game_loaded

var default_room: RoomDef = Registries.ROOMS.SKI_VILLAGE


func _ready() -> void:
	NetworkManager.connected.connect(_on_connected)
	NetworkManager.disconnected.connect(_on_disconnected)
	NetworkManager.connection_failed.connect(_on_connection_failed)
	NetworkManager.packet_received.connect(_on_packet_received)
	
	SessionManager.login_success.connect(_on_login_success)

	Registries.UI_WINDOWS.SPINNER.cache()
	Registries.UI_WINDOWS.LOADER.cache()

	UIManager.set_root(Registries.UI_WINDOWS.MAIN_MENU)
	var spinner: UIWindow = UIManager.push(Registries.UI_WINDOWS.SPINNER)
	
	if SessionManager.load_session():
		NetworkManager.connect_to_server(SessionManager.current_token)
	else:
		if spinner:
			spinner.close()


func _on_login_success() -> void:
	UIManager.push(Registries.UI_WINDOWS.SPINNER)
	NetworkManager.connect_to_server(SessionManager.current_token)


func _on_connected() -> void:
	print("GameManager: Connected to server.")
	
	var loader: UIWindow = UIManager.push(Registries.UI_WINDOWS.LOADER, { "close_on": game_loaded })
	
	var join_packet: Dictionary = PacketBuilder.create_join_packet(GameManager.default_room)
	NetworkManager.send_packet(join_packet)
	
	UIManager.set_root(Registries.UI_WINDOWS.HUD, {}, false, [loader])


func _on_packet_received(data: Dictionary) -> void:
	Registries.HANDLERS.process_packet(data)


func _on_connection_failed() -> void:
	print("GameManager: Connection failed.")
	_return_to_auth()
	UIManager.push(Registries.UI_WINDOWS.POPUP, {
		"title": "Error",
		"text": "Connection failed."
	})


func _on_disconnected() -> void:
	print("GameManager: Disconnected.")
	_return_to_auth()
	UIManager.push(Registries.UI_WINDOWS.POPUP, {
		"title": "Error",
		"text": "Disconnected from the server."
	})


func _return_to_auth() -> void:
	ChatManager.clear_log()
	WorldManager.unload_current_room()
	SessionManager.clear_session()
	
	UIManager.set_root(Registries.UI_WINDOWS.MAIN_MENU)
