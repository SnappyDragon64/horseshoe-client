@tool
class_name UIViewDef
extends Definition

## A lazy-loaded proxy for [UIView] scenes.
##
## Stores the file path to a UI scene.
## Used by [UIStack] to instantiate views on demand.

func _get_path_hint() -> String:
	return "*.tscn"


func get_scene() -> PackedScene:
	assert(not path.is_empty(), 
		"UIViewDef [%s]: Failed to get scene." % 
		[id if not id.is_empty() else &"UNREGISTERED"]
	)
	return get_resource() as PackedScene
