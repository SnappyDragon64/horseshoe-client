@abstract
class_name Registry
extends RefCounted

## A base container for managing collections of [Definition] objects and other values, including 
## objects, callables, and primitive data types.
##
## Registry provides a central point for item registration, ID validation, and lookup. 
## It is designed to be inherited by specific domain registries.

## Internal registry map.
var _registry: Dictionary = {}


## Registers an item under the specified [param id] and handles ID stamping.
## Item can be a [Definition] defined in code, loaded from the file system or other values such as
## objects, callables, and primitive data types.
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


## Returns [code]true[/code] if the registry contains an item with the given [param id].
func has(id: StringName) -> bool:
	return _registry.has(id)


## Returns the item associated with [param id]. 
func get_by_id(id: StringName) -> Variant:
	if has(id):
		return _registry[id]
	else:
		push_warning("Registry %s: Item '%s' not found" % [get_script().get_global_name(), id])
		return null


## Returns an [Array] of all registered IDs.
func get_ids() -> Array[StringName]:
	return _registry.keys()


## Returns an [Array] of all registered items.
func get_all() -> Array[Variant]:
	return _registry.values()


## Clears the cache for every [Definition] in the registry.
func flush_cache() -> void:
	for item: Variant in _registry.values():
		if item is Object and item.has_method("free_cache"):
			item.free_cache()
