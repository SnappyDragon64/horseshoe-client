class_name Handlers
extends Registry


var LOAD_ROOM:      Handler = _register("load_room",      HandleLoadRoom.new())
var SPAWN_PLAYER:   Handler = _register("spawn_player",   HandleSpawn.new())
var DELETE_PLAYER:  Handler = _register("delete_player",  HandleDelete.new())
var PLAYER_MOVED:   Handler = _register("player_moved",   HandleMove.new())
var PLAYER_MESSAGE: Handler = _register("player_message", HandleChat.new())


func process_packet(data: Dictionary) -> void:
	var type: String = data.get("type", "")
	var handler: Handler = by_id(type)
	
	if handler:
		handler.execute(data)
	else:
		print_debug("Unknown packet type: ", type)
