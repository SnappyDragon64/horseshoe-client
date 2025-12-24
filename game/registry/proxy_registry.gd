@abstract
class_name ProxyRegistry
extends Registry


func flush_cache() -> void:
	for entry: ProxyDef in get_values():
		entry.free_cache()
