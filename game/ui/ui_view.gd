class_name UIView
extends Control


signal opened
signal closed
signal suspended
signal resumed

var _suspended := false
var _closed := false

@export var close_on_escape := false
@export var hide_previous := false


func _ready() -> void:
	visible = false


func _setup(_props: Dictionary[String, Variant]) -> void:
	for key: String in _props.keys():
		if key in self:
			self.set(key, _props[key])
		else:
			push_warning("%s: Attempted setting invalid prop %s = %s on node %s" % [get_script().get_class(), key, _props[key], get_path()])


func _open() -> void:
	visible = true
	@warning_ignore("redundant_await")
	await _animate_show()
	opened.emit()


func _close() -> void:
	@warning_ignore("redundant_await")
	await _animate_hide()
	closed.emit()


func _suspend() -> void:
	if _suspended:
		suspended.emit()
		return
	
	_suspended = true
	@warning_ignore("redundant_await")
	await _animate_hide()
	visible = false
	suspended.emit()


func _resume() -> void:
	if not _suspended:
		resumed.emit()
		return
	
	_suspended = false
	visible = true
	@warning_ignore("redundant_await")
	await _animate_show()
	resumed.emit()


func _animate_show() -> void:
	show()


func _animate_hide() -> void:
	hide()


func grab_default_focus() -> void:
	pass


func close() -> void:
	if _closed:
		return
	
	_closed = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_close()
