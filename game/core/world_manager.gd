extends Node


const SCENE_PLAYER: PackedScene = preload("res://game/world/entity/player.tscn")

var _current_room: Room = null
var _players: Dictionary[String, Player] = {}


func _ready() -> void:
	ChatManager.bubble_requested.connect(_on_bubble_requested)


func _on_bubble_requested(author: String, text: String) -> void:
	if _players.has(author):
		_players.get(author).display_message(text)


func load_room(room: RoomDef, spawn_pos: Vector2, player_list: Array = []) -> void:
	var local_id: String = SessionManager.current_username
	var facing: Vector2 = _players[local_id].sprite.scale if _players.has(local_id) else Vector2.ONE
	
	await unload_current_room()
	
	var room_scene: PackedScene = room.get_resource()
	_current_room = room_scene.instantiate() 
	add_child(_current_room)
	
	spawn_player(local_id, spawn_pos, true)
	_players[local_id].sprite.scale = facing
	
	for player_data: Dictionary in player_list:
		if player_data.id != local_id:
			spawn_player(player_data.id, Vector2(player_data.pos.x, player_data.pos.y))


func unload_current_room() -> void:
	if _current_room:
		_current_room.queue_free()
		await _current_room.tree_exited
	
	_players.clear()
	_current_room = null


func spawn_player(id: String, pos: Vector2, is_local: bool = false) -> Player:
	if _players.has(id):
		return null
		
	var player: Player = SCENE_PLAYER.instantiate()
	player.player_name = id
	player.position = pos
	
	player.is_local = is_local
	
	_current_room.add_child(player)
		
	_players.set(id, player)
	
	return player


func move_player(id: String, target: Vector2) -> void:
	if _players.has(id):
		_players.get(id).move_to(target)


func remove_player(id: String) -> void:
	if _players.has(id):
		_players.get(id).queue_free()
		_players.erase(id)
