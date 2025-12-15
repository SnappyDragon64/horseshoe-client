extends Node


const SCENE_PLAYER: PackedScene = preload("res://game/world/entity/player.tscn")

var current_room: Room = null
var players: Dictionary = {}


func _ready() -> void:
	ChatManager.bubble_requested.connect(_on_bubble_requested)


func _on_bubble_requested(author: String, text: String) -> void:
	if players.has(author):
		players.get(author).display_message(text)


func load_room(room_data: RoomData, spawn_pos: Vector2, player_list: Array = []) -> void:
	unload_current_room()
	
	var room_scene: PackedScene = load(room_data.scene_path)
	current_room = room_scene.instantiate() 
	add_child(current_room)
	
	var local_id: String = SessionManager.current_username
	
	current_room._local_player = spawn_player(local_id, spawn_pos, true)
	
	for player_data: Dictionary in player_list:
		if player_data.id != local_id:
			spawn_player(player_data.id, Vector2(player_data.pos.x, player_data.pos.y))


func unload_current_room() -> void:
	if current_room:
		current_room.queue_free()
	
	players.clear()
	current_room = null


func spawn_player(id: String, pos: Vector2, is_local: bool = false) -> Player:
	if players.has(id):
		return null
		
	var player: Player = SCENE_PLAYER.instantiate()
	player.player_name = id
	player.position = pos
	
	player.is_local = is_local
	
	current_room.add_child(player)
		
	players.set(id, player)
	
	return player


func move_player(id: String, target: Vector2) -> void:
	if players.has(id):
		players.get(id).move_to(target)


func remove_player(id: String) -> void:
	if players.has(id):
		players.get(id).queue_free()
		players.erase(id)
