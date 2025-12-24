extends CanvasLayer


var dimmer: ColorRect

var _view_stack: Array[UIView] = []


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
	
	if event.is_action_pressed("ui_cancel") and top.close_on_escape and _view_stack.size() > 1:
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
		top.grab_default_focus.call_deferred()


func _update_dimmer_state() -> void:
	dimmer.visible = false
	
	if _view_stack.is_empty():
		return

	var index := -1
	
	for i in range(_view_stack.size() - 1, -1, -1):
		var view := _view_stack[i]
		
		if view.visible and view.is_modal:
			index = view.get_index() - 1
			break

	if index != -1:
		dimmer.visible = true
		move_child(dimmer, index)


func _get_ui_view(def: UIViewDef) -> UIView:
	var scene: PackedScene = def.get_scene()
	return scene.instantiate()


func push(entry: UIViewDef, props: Dictionary[String, Variant] = {}) -> UIView:
	if not entry:
		return null
	
	var view: UIView = _get_ui_view(entry)
	
	if not view:
		return null

	view._setup(props)
	
	add_child(view)
	_view_stack.append(view)
	
	clear_focus()
	
	view.closed.connect(func() -> void: _pop_view(view))
	view._open()
	
	_update_dimmer_state()
	
	view.grab_default_focus.call_deferred()
	
	return view


func set_root(entry: UIViewDef, flush_except: Array[UIView] = [], props: Dictionary[String, Variant] = {}) -> UIView:
	flush(flush_except)
	
	if not entry:
		return null
	
	var view: UIView = _get_ui_view(entry)
	
	if not view:
		return null

	view._setup(props)
	
	add_child(view)
	move_child(view, 0)
	_view_stack.push_front(view)
	
	view.closed.connect(_pop_view, CONNECT_APPEND_SOURCE_OBJECT)
	view._open()
	
	_update_dimmer_state()
	
	if _view_stack.back() == view:
		clear_focus()
		view.grab_default_focus.call_deferred()

	return view


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
