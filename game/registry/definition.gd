@tool
@abstract
class_name Definition
extends Resource


@export var id: StringName
@export_file var path: String

var _cache: Resource


func _init(p_path: String = "", p_id: StringName = &"") -> void:
	path = p_path
	id = p_id


func _validate_property(property: Dictionary) -> void:
	if property.name == "path":
		var hint_string := _get_path_hint()
		
		if not hint_string.is_empty():
			property.hint = PROPERTY_HINT_FILE
			property.hint_string = hint_string
			
		if hint_string == "HIDE":
			property.usage = PROPERTY_USAGE_NONE


func _get_path_hint() -> String:
	return ""


func get_resource() -> Resource:
	if _cache: 
		return _cache
	
	return load(path) if not path.is_empty() else self


func cache() -> void:
	if not _cache and not path.is_empty():
		_cache = load(path)


func free_cache() -> void:
	_cache = null
