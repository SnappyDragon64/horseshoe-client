class_name Handlers
extends Registry


var CONNECT:        Handler = register("connect",        HandleConnect.new())
var LOAD_ROOM:      Handler = register("load_room",      HandleLoadRoom.new())
var SPAWN_PLAYER:   Handler = register("spawn_player",   HandleSpawn.new())
var DELETE_PLAYER:  Handler = register("delete_player",  HandleDelete.new())
var PLAYER_MOVED:   Handler = register("player_moved",   HandleMove.new())
var PLAYER_MESSAGE: Handler = register("player_message", HandleChat.new())


func process_packet(data: Dictionary) -> void:
	var type: String = data.get("type", "")
	var handler: Handler = by_id(type)
	
	if handler:
		handler.execute(data)
	else:
		print_debug("Unknown packet type: ", type)
