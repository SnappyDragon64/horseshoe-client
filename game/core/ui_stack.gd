extends CanvasLayer

## Global manager for UI stacking, navigation, and focus.
##
## [UIStack] handles the lifecycle of [UIView] instances.

## Internal representation of the active UI stack.
var _view_stack: Array[UIView] = []

## Guards against concurrent push operations.
var _pushing := false



func _ready() -> void:
	layer = 100
	set_process_unhandled_input(true)


func _unhandled_input(event: InputEvent) -> void:
	if _view_stack.is_empty():
		return

	var top: UIView = _view_stack.back()
	
	if event.is_action_pressed("ui_cancel") and top.close_on_escape and _view_stack.size() > 1:
		top.close()
		get_viewport().set_input_as_handled()


func _pop_view(view: UIView) -> void:
	if not _view_stack.has(view):
		return
	
	_view_stack.erase(view)
	view.queue_free()
	
	if not _view_stack.is_empty():
		var top: UIView = _view_stack.back()
		
		if top._suspended:
			top._resume()
			await top.resumed
		
		top.grab_default_focus.call_deferred()


func _instantiate_view(def: UIViewDef) -> UIView:
	var scene: PackedScene = def.get_scene()
	var view: UIView = scene.instantiate()
	return view


## Instantiates a view from [param def] and adds it to the top of the stack.
## Injects [param props] into the instance before it enters the tree.
## Returns the instance immediately; animations are handled asynchronously.
func push(def: UIViewDef, props: Dictionary[String, Variant] = {}) -> UIView:
	if _pushing:
		return null
	
	if not def:
		return null
	
	_pushing = true
	
	var previous_view: UIView = _view_stack.back() if not _view_stack.is_empty() else null
	
	var view: UIView = _instantiate_view(def)
	view.closed.connect(func() -> void: _pop_view(view))
	view._setup(props)
	
	add_child(view)
	_view_stack.append(view)
	
	clear_focus()
	
	_handle_push(view, previous_view)
	
	_pushing = false
	
	return view


## Manages the transition sequence for a newly pushed view.
func _handle_push(view: UIView, previous_view: UIView) -> void:
	if view.hide_previous and is_instance_valid(previous_view) and not previous_view._closed:
		previous_view._suspend()
		await previous_view.suspended
	
	view._open()
	await view.opened
	
	view.grab_default_focus.call_deferred()


## Replaces the entire stack with a new base view. 
## Existing views are removed via [method flush], excluding those in [param flush_except].
func set_root(def: UIViewDef, flush_except: Array[UIView] = [], props: Dictionary[String, Variant] = {}) -> UIView:
	if not def:
		return null
	
	_pushing = true
	
	flush(flush_except)
	
	var view: UIView = _instantiate_view(def)
	view.closed.connect(func() -> void: _pop_view(view))
	view._setup(props)
	
	add_child(view)
	move_child(view, 0)
	_view_stack.push_front(view)
	
	clear_focus()
	
	_handle_set_root(view)
	
	_pushing = false
	
	return view


## Manages the transition sequence for a newly set root view.
func _handle_set_root(view: UIView) -> void:
	view._open()
	await view.opened
	
	if _view_stack.back() == view:
		view.grab_default_focus.call_deferred()


## Immediately destroys all views in the stack except for those in the [param except] list.
func flush(except: Array[UIView] = []) -> void:
	for i in range(_view_stack.size() - 1, -1, -1):
		var view: UIView = _view_stack[i]
		
		if view not in except:
			_view_stack.remove_at(i)
			view.queue_free()


## Releases the current GUI focus owner from the [Viewport].
func clear_focus() -> void:
	var viewport := get_viewport()
	
	if viewport.gui_get_focus_owner():
		viewport.gui_release_focus()
