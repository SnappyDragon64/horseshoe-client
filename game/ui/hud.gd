extends CanvasLayer

var max_characters := 120

@onready var line_edit: LineEdit = $PanelContainer/MarginContainer/HBoxContainer/LineEdit


func _on_line_edit_text_changed(_new_text: String) -> void:
	if line_edit.text.length() > max_characters:
		line_edit.text = line_edit.text.left(max_characters)
		line_edit.caret_column = line_edit.text.length()


func _on_line_edit_text_submitted(_new_text: String) -> void:
	_submit_message()


func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		_submit_message()
		get_viewport().set_input_as_handled()


func _on_button_pressed() -> void:
	_submit_message()
	line_edit.grab_focus()


func _submit_message() -> void:
	var text: String = line_edit.text
	
	if len(text) > 0 and WorldManager.local_player:
		WorldManager.local_player.display_message(text)
		NetworkManager.send_packet({
			"type": "chat",
			"message": text
		})
		line_edit.clear()
