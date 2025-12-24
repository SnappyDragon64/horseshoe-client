extends CanvasLayer


var dimmer: ColorRect

var _window_stack: Array[UIWindow] = []


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


func push(entry: UIWindows.UIWindowDef, props: Dictionary[String, Variant] = {}, cache_scene: bool = false) -> UIWindow:
	if not entry:
		return null
	
	var window: UIWindow = entry.instantiate(cache_scene)
	
	if not window:
		return null

	window._setup(props)
	
	add_child(window)
	_window_stack.append(window)
	
	clear_focus()
	
	window.closed.connect(func() -> void: _pop_window(window))
	window._open()
	
	_update_dimmer_state()
	
	window.grab_default_focus.call_deferred()
	
	return window


func set_root(entry: UIWindows.UIWindowDef, props: Dictionary[String, Variant] = {}, cache_scene: bool = false, flush_except: Array[UIWindow] = []) -> UIWindow:
	flush(flush_except)
	
	if not entry:
		return null
	
	var window: UIWindow = entry.instantiate(cache_scene)
	
	if not window:
		return null

	window._setup(props)
	
	add_child(window)
	move_child(window, 0)
	_window_stack.push_front(window)
	
	window.closed.connect(_pop_window, CONNECT_APPEND_SOURCE_OBJECT)
	window._open()
	
	_update_dimmer_state()
	
	if _window_stack.back() == window:
		clear_focus()
		window.grab_default_focus.call_deferred()

	return window


func flush(except: Array[UIWindow] = []) -> void:
	for i in range(_window_stack.size() - 1, -1, -1):
		var window: UIWindow = _window_stack[i]
		
		if window not in except:
			_window_stack.remove_at(i)
			window.queue_free()
	
	_update_dimmer_state()


func clear_focus() -> void:
	var viewport := get_viewport()
	
	if viewport.gui_get_focus_owner():
		viewport.gui_release_focus()


func _pop_window(window: UIWindow) -> void:
	if not _window_stack.has(window):
		return
	
	_window_stack.erase(window)
	window.queue_free()
	_update_dimmer_state()
	
	if not _window_stack.is_empty():
		var top: UIWindow = _window_stack.back()
		top.grab_default_focus.call_deferred()


func _update_dimmer_state() -> void:
	dimmer.visible = false
	
	if _window_stack.is_empty():
		return

	var index := -1
	
	for i in range(_window_stack.size() - 1, -1, -1):
		var window := _window_stack[i]
		
		if window.visible and window.is_modal:
			index = window.get_index() - 1
			break

	if index != -1:
		dimmer.visible = true
		move_child(dimmer, index)


func _unhandled_input(event: InputEvent) -> void:
	if _window_stack.is_empty():
		return

	var top: UIWindow = _window_stack.back()
	
	if event.is_action_pressed("ui_cancel") and top.close_on_escape and _window_stack.size() > 1:
		top.close()
		get_viewport().set_input_as_handled()
