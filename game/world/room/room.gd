@tool
class_name Room
extends Node2D


@export var data: RoomData

@onready var navigation_region: NavigationRegion2D = $NavigationRegion2D

var _local_player: Player = null


func _ready() -> void:
	_setup_camera()


func _get_configuration_warnings() -> PackedStringArray:
	return [""] if find_children("*", "NavigationRegion2D").size() > 0 else ["Room node requires a NavigationRegion2D child."]


func _setup_camera() -> void:
	var cam := self.find_children("*", "Camera2D")

	if len(cam) > 0:
		return
	
	var camera := Camera2D.new()
	add_child(camera)


func _unhandled_input(event: InputEvent) -> void:
	if not _local_player:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var global_click_pos: Vector2 = get_global_mouse_position()
			
			var map_rid: RID = NavigationServer2D.get_maps()[0]
			
			var final_target_pos: Vector2 = NavigationServer2D.map_get_closest_point(map_rid, global_click_pos)
			
			WorldManager.process_local_move(final_target_pos)

			get_viewport().set_input_as_handled()
