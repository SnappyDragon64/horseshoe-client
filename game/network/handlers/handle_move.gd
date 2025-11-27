class_name HandleMove
extends Handler


func execute(data: Dictionary) -> void:
	var id: String = data.id
	var target := Vector2(data.target.x, data.target.y)
	WorldManager.move_entity(id, target)
