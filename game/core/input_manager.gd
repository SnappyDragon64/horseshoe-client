extends Node2D


const DEADZONE_THRESHOLD: float = 10.0
const DEBOUNCE_TIME: float = 1.0

var last_sent_target: Vector2 = Vector2.INF
var is_debounce_active: bool = false
var has_pending_move: bool = false
var pending_target: Vector2 = Vector2.ZERO

var _debounce_timer: Timer


func _ready() -> void:
	_debounce_timer = Timer.new()
	_debounce_timer.one_shot = true
	_debounce_timer.wait_time = DEBOUNCE_TIME
	_debounce_timer.timeout.connect(_on_debounce_timer_timeout)
	add_child(_debounce_timer)


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return

	var global_click_pos: Vector2 = get_global_mouse_position()

	var maps := NavigationServer2D.get_maps()
	
	if maps.is_empty():
		return
	
	var map: RID = maps[0]
	var final_target: Vector2 = NavigationServer2D.map_get_closest_point(map, global_click_pos)

	_process_move_request(final_target)
	
	get_viewport().set_input_as_handled()


func _process_move_request(target_pos: Vector2) -> void:
	if target_pos.distance_to(last_sent_target) < DEADZONE_THRESHOLD:
		return

	WorldManager.move_player(SessionManager.current_username, target_pos)

	if is_debounce_active:
		has_pending_move = true
		pending_target = target_pos
	else:
		_send_network_packet(target_pos)
		is_debounce_active = true
		_debounce_timer.start()


func _on_debounce_timer_timeout() -> void:
	is_debounce_active = false
	
	if has_pending_move:
		_send_network_packet(pending_target)
		
		has_pending_move = false
		pending_target = Vector2.ZERO


func _send_network_packet(target_pos: Vector2) -> void:
	last_sent_target = target_pos
	var packet: Dictionary = PacketBuilder.create_move_packet(target_pos)
	NetworkManager.send_packet(packet)
