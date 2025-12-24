class_name UIWindow
extends Control


signal opened
signal closed

@export var is_modal: bool = true
@export var close_on_escape: bool = true

var _closing: bool = false


func _setup(_props: Dictionary[String, Variant]) -> void:
	for key: String in _props.keys():
		if key in self:
			self.set(key, _props[key])
		else:
			push_warning("%s: Attempted setting invalid prop %s = %s on node %s" % [get_script().get_class(), key, _props[key], get_path()])


func _open() -> void:
	opened.emit()


func _close() -> void:
	hide()
	closed.emit()


func grab_default_focus() -> void:
	pass


func close() -> void:
	if not _closing:
		_closing = true
		_close()
