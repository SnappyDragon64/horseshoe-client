@abstract
class_name ProxyDef
extends RefCounted


var _path: String
var _cache: Resource = null


func _init(path: String) -> void:
	_path = path


func cache() -> void:
	if not _cache:
		_cache = load(_path)


func free_cache() -> void:
	_cache = null


func get_resource() -> Resource:
	return _cache if _cache else load(_path)
