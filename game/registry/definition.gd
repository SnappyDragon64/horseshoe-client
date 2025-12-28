@tool
@abstract
class_name Definition
extends Resource

## Base class for lazy-loaded resource proxies.
##
## Definition acts as a lightweight holder that stores an ID and a file path. 
## It prevents assets from being loaded into memory until [method get_resource] is explicitly
## called. This indirection allows for large registries to be loaded in RAM with minimal footprint.
	
## The unique identifier for this definition within its registry.
## If left blank, it will be stamped during registration.
@export var id: StringName
## The filesystem path to the  resource this definition represents.
## This can be empty if not required.
@export_file var path: String

## Internal cache to store the loaded resource.
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


## Method to provide a file filter for the [member path] in the Inspector.
## Subclasses should override this to restrict files to specific extensions (e.g., "*.tscn").
## Return "HIDE" to entirely hide the [member path] in the Inspector.
func _get_path_hint() -> String:
	return ""


## Returns the resource represented by this definition.
## If [member path] is empty, it returns the [Definition] instance itself, allowing 
## it to act as a standalone data container.
func get_resource() -> Resource:
	if _cache: 
		return _cache
	
	return load(path) if not path.is_empty() else self


## Synchronously loads the resource into the internal cache.
## This allows explicit caching of resources.
func cache() -> void:
	if not _cache and not path.is_empty():
		_cache = load(path)


## Frees the internal cache for this [Definition].
func free_cache() -> void:
	_cache = null
