class_name Registry
extends RefCounted


var _registry: Dictionary = {}


func _register(id: StringName, item: Variant) -> Variant:
	if _registry.has(id):
		push_warning("Registry %s: Duplicate registration for '%s'" % [get_script().get_global_name(), id])

	if item is Object and "id" in item:
		var item_id: StringName = item.id
		
		if item_id.is_empty():
			item.id = id
		else:
			assert(item_id == id, "Registry [%s]: ID mismatch. Key is '%s' but Resource ID is '%s'." % [get_script().get_global_name(), id, item_id])
	
	_registry[id] = item
	return item


func has(id: String) -> bool:
	return _registry.has(id)


func get_by_id(id: String) -> Variant:
	if has(id):
		return _registry[id]
	else:
		push_warning("Registry %s: Item '%s' not found" % [get_script().get_global_name(), id])
		return null


func get_ids() -> Array:
	return _registry.keys()


func get_all() -> Array:
	return _registry.values()


func flush_cache() -> void:
	for item: Variant in _registry.values():
		if item is Object and item.has_method("free_cache"):
			item.free_cache()
