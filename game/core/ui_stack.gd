extends CanvasLayer


var dimmer: ColorRect

var _view_stack: Array[UIView] = []

var _pushing := false



func _ready() -> void:
	layer = 100
	set_process_unhandled_input(true)
	_setup_dimmer()


func _setup_dimmer() -> void:
	dimmer = ColorRect.new()
	dimmer.name = "Dimmer"
	dimmer.color = Color(0,0,0,0.5)
	dimmer.set_anchors_preset(Control.PRESET_FULL_RECT)
	dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
	dimmer.visible = false
	add_child(dimmer)


func _unhandled_input(event: InputEvent) -> void:
	if _view_stack.is_empty():
		return

	var top: UIView = _view_stack.back()
	
	if event.is_action_pressed("ui_cancel") and top._close_on_escape and _view_stack.size() > 1:
		top.close()
		get_viewport().set_input_as_handled()


func _pop_view(view: UIView) -> void:
	if not _view_stack.has(view):
		return
	
	_view_stack.erase(view)
	view.queue_free()
	_update_dimmer_state()
	
	if not _view_stack.is_empty():
		var top: UIView = _view_stack.back()
		
		if top._suspended:
			top._resume()
			await top.resumed
		
		top.grab_default_focus.call_deferred()


func _update_dimmer_state() -> void:
	dimmer.visible = false
	
	if _view_stack.is_empty():
		return

	var index := -1
	
	for i in range(_view_stack.size() - 1, -1, -1):
		var view := _view_stack[i]
		
		if view.visible and view._is_modal:
			index = view.get_index() - 1
			break

	if index != -1:
		dimmer.visible = true
		move_child(dimmer, index)


func _instantiate_view(def: UIViewDef) -> UIView:
	var scene: PackedScene = def.get_scene()
	var view: UIView = scene.instantiate()
	
	view._id = def.id
	view._is_modal = def.is_modal
	view._close_on_escape = def.close_on_escape
	view._hide_previous = def.hide_previous
	
	return view


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
	_update_dimmer_state()
	
	_handle_push(def, view, previous_view)
	
	return view


func _handle_push(def: UIViewDef, view: UIView, previous_view: UIView) -> void:
	if def.hide_previous and is_instance_valid(previous_view) and not previous_view._closed:
		previous_view._suspend()
		await previous_view.suspended
	
	view._open()
	await view.opened
	
	_pushing = false
	
	view.grab_default_focus.call_deferred()


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
	_update_dimmer_state()
	
	_handle_set_root(view)
	
	return view


func _handle_set_root(view: UIView) -> void:
	view._open()
	await view.opened

	_pushing = false
	
	if _view_stack.back() == view:
		view.grab_default_focus.call_deferred()


func flush(except: Array[UIView] = []) -> void:
	for i in range(_view_stack.size() - 1, -1, -1):
		var view: UIView = _view_stack[i]
		
		if view not in except:
			_view_stack.remove_at(i)
			view.queue_free()
	
	_update_dimmer_state()


func clear_focus() -> void:
	var viewport := get_viewport()
	
	if viewport.gui_get_focus_owner():
		viewport.gui_release_focus()
