extends Node


var current_room: Node2D = null
var local_player_id: String = ""
var local_player: Player = null

var players: Dictionary = {}

var scene_player: PackedScene = preload("res://game/world/entities/player.tscn")


func load_room(room_id: String, spawn_pos: Vector2, player_list: Array = []) -> void:
	var room: Room = Registries.ROOMS.by_id(room_id)
	if not room:
		return

	if current_room:
		current_room.queue_free()
	
	players.clear()
	
	var room_scene: PackedScene = load(room.scene_path)
	current_room = room_scene.instantiate()
	add_child(current_room)
	
	spawn_player(local_player_id, spawn_pos, true)
	
	for player: Dictionary in player_list:
		spawn_player(player.id, Vector2(player.pos.x, player.pos.y))


func spawn_player(id: String, pos: Vector2, is_local: bool = false) -> Player:
	if players.has(id):
		return
		
	var player: Player = scene_player.instantiate()
	player.player_name = id
	player.position = pos
	
	player.is_local = is_local
	
	current_room.add_child(player)
		
	players[id] = player
	
	if is_local:
		local_player = player
	
	return player


func remove_player(id: String) -> void:
	if players.has(id):
		players[id].queue_free()
		players.erase(id)


func move_player(id: String, target: Vector2) -> void:
	if players.has(id):
		players[id].move_to(target)


func chat_player(id: String, msg: String) -> void:
	if players.has(id):
		players[id].display_message(msg)
