@abstract class_name DataRegistry
extends Registry


const _PATH_TEMPLATE: String = "res://data/%s/%s.tres"


@abstract func _get_registry_id() -> String


func _register(id: String, variant: Variant = null) -> Data:
	var data_resource: Data = variant if variant else load(_PATH_TEMPLATE % [_get_registry_id(), id])
	
	if data_resource.id != id:
		push_warning("%s: ID mismatch for ID %s and Resource %s" % [get_script().get_global_name(), id, data_resource.id])
	
	return super._register(id, data_resource)
