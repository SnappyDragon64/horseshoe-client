extends Node


signal connected
signal disconnected
signal packet_received(data: Dictionary)

var socket: WebSocketPeer = WebSocketPeer.new()
var websocket_url: String = "ws://localhost:8080/ws" if false else ProjectSettings.get_setting("application/config/server_url")
var _connected := false


func connect_to_server(token: String) -> void:
	var url := "%s?token=%s" % [websocket_url, token]
	
	var err: Error = socket.connect_to_url(url)
	
	if err == OK:
		print("Connecting to %s..." % websocket_url)
	else:
		push_error("Unable to connect.")
		set_process(false)


func send_packet(data: Dictionary) -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
		socket.send_text(JSON.stringify(data))


func _process(_delta: float) -> void:
	socket.poll()
	var state: WebSocketPeer.State = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		if not _connected:
			_connected = true
			connected.emit()
		
		while socket.get_available_packet_count():
			var packet_bytes: PackedByteArray = socket.get_packet()
			
			var packet_string: String = packet_bytes.get_string_from_utf8()
			var json: Dictionary = JSON.parse_string(packet_string)
			
			if json:
				packet_received.emit(json)
			else:
				print("Error parsing JSON: ", packet_string)

	elif state == WebSocketPeer.STATE_CLOSED:
		_connected = false
		disconnected.emit()
		set_process(false)
