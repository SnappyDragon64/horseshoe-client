extends CanvasLayer


@onready var line_edit: LineEdit = $PanelContainer/MarginContainer/HBoxContainer/LineEdit


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
		var packet: Dictionary = PacketBuilder.create_chat_packet(text)
		NetworkManager.send_packet(packet)
		line_edit.clear()
