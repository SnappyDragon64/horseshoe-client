@abstract
class_name ResourceRegistry
extends Registry


const _PATH_TEMPLATE: String = "res://definition/%s/%s.tres"


@abstract func _get_registry_id() -> String


func _register(id: String, variant: Variant = null) -> ResourceDef:
	var resource_def: ResourceDef = variant if variant else load(_PATH_TEMPLATE % [_get_registry_id(), id])
	
	if resource_def.id != id:
		push_warning("%s: ID mismatch for ID %s and Resource %s" % [get_script().get_global_name(), id, resource_def.id])
	
	return super._register(id, resource_def)
