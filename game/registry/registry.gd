@abstract
class_name Registry
extends RefCounted


var _registry: Dictionary[String, Variant] = {}


func _register(id: String, variant: Variant) -> Variant:
	if id in _registry:
		push_warning("{0}: Duplicate registration for {1}".format([get_script().get_global_name(), id]))
	else:
		_registry.set(id, variant)
	
	return variant


func has(id: String) -> Variant:
	return _registry.has(id)


func by_id(id: String) -> Variant:
	if has(id):
		return _registry.get(id)
	else:
		push_warning("{0}: {1} not found".format([get_script().get_global_name(), id]))
		return null


func get_ids() -> Array[String]:
	return _registry.keys()


func get_values() -> Array[Variant]:
	return _registry.values()
