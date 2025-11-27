@abstract class_name Registry
extends RefCounted


var _registry: Dictionary[String, Variant] = {}


func register(id: String, variant: Variant) -> Variant:
	if id in _registry:
		push_warning("{0}: Duplicate registration for {1}".format([get_script().get_class(), id]))
	else:
		_registry[id] = variant
	
	return variant


func has(id: String) -> Variant:
	return id in _registry


func by_id(id: String) -> Variant:
	if has(id):
		return _registry[id]
	else:
		push_warning("{0}: {1} not found".format([get_script().get_class(), id]))
		return null
