extends Node

signal connected
signal disconnected
signal connection_failed
signal packet_received(data: Dictionary)

var socket: WebSocketPeer
var _connected := false

var websocket_url: String = "ws://localhost:8080/ws" if false else ProjectSettings.get_setting("application/config/server_url")


func _ready() -> void:
	set_process(false)


func connect_to_server(token: String) -> void:
	if socket:
		socket.close()
		socket = null
	
	_connected = false
	socket = WebSocketPeer.new()
	
	var url := "%s?token=%s" % [websocket_url, token]
	
	print("NetworkManager: Connecting to %s..." % websocket_url)
	
	var err: Error = socket.connect_to_url(url)
	
	if err == OK:
		set_process(true)
	else:
		push_error("NetworkManager: Immediate connection error: %s" % err)
		connection_failed.emit()
		set_process(false)


func send_packet(data: Dictionary) -> void:
	if not socket:
		return
		
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		socket.send_text(JSON.stringify(data))


func _process(_delta: float) -> void:
	if not socket:
		set_process(false)
		return

	socket.poll()
	
	var state: WebSocketPeer.State = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		if not _connected:
			_connected = true
			print("NetworkManager: Websocket Open!")
			connected.emit()
		
		while socket.get_available_packet_count():
			var packet_bytes: PackedByteArray = socket.get_packet()
			
			var packet_string: String = packet_bytes.get_string_from_utf8()
			var json: Dictionary = JSON.parse_string(packet_string)
			packet_received.emit(json)

	elif state == WebSocketPeer.STATE_CLOSED:
		if _connected:
			print("NetworkManager: Disconnected cleanly.")
			_connected = false
			disconnected.emit()
		else:
			print("NetworkManager: Connection refused (Auth failed or Server down).")
			connection_failed.emit()
			
		set_process(false)
