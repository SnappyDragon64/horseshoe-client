class_name UIView
extends Control

## Base class for all UI screens and overlays.
##
## [UIView] provides the foundational lifecycle hooks for the [UIStack].
## It is designed to be extended by specific UI scenes.

## Emitted when the view has finished opening.
signal opened
## Emitted when the view has finished closing.
signal closed
## Emitted when the view has finished suspending.
signal suspended
## Emitted when the view has finished resuming.
signal resumed

var _suspended := false
var _closed := false

## If [code]true[/code], [UIStack] will close this view when 'ui_cancel' is pressed.
@export var close_on_escape := false
## If [code]true[/code], [UIStack] will suspend and hide the view underneath when this is pushed.
@export var hide_previous := false


func _ready() -> void:
	visible = false


## Internal setup called by [UIStack] immediately after instantiation.
## Injects [param _props] into matching properties on this instance.
func _setup(_props: Dictionary[String, Variant]) -> void:
	for key: String in _props.keys():
		if key in self:
			self.set(key, _props[key])
		else:
			push_warning("%s: Attempted setting invalid prop %s = %s on node %s" % [get_script().get_class(), key, _props[key], get_path()])


## Called by [UIStack] to trigger the opening sequence.
## This is a lifecycle method only for use by [UIStack].
func _open() -> void:
	visible = true
	@warning_ignore("redundant_await")
	await _animate_show()
	opened.emit()


## Called by [UIStack] to trigger the closing sequence.
## This is a lifecycle method only for use by [UIStack].
func _close() -> void:
	@warning_ignore("redundant_await")
	await _animate_hide()
	closed.emit()


## Called by [UIStack] when a new view with [member hide_previous] is pushed on top.
## This is a lifecycle method only for use by [UIStack].
func _suspend() -> void:
	if _suspended:
		suspended.emit()
		return
	
	_suspended = true
	@warning_ignore("redundant_await")
	await _animate_hide()
	visible = false
	suspended.emit()


## Called by [UIStack] when the view on top is popped if this was suspended.
## This is a lifecycle method only for use by [UIStack].
func _resume() -> void:
	if not _suspended:
		resumed.emit()
		return
	
	_suspended = false
	visible = true
	@warning_ignore("redundant_await")
	await _animate_show()
	resumed.emit()


## Method for show animations. Override to implement custom Tweens or transitions.
func _animate_show() -> void:
	show()


## Method for hide animations. Override to implement custom Tweens or transitions.
func _animate_hide() -> void:
	hide()


## Method for initial focus handling. Called by [UIStack] after the view is fully visible.
func grab_default_focus() -> void:
	pass


## Initiates the close sequence.
func close() -> void:
	if _closed:
		return
	
	_closed = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_close()
