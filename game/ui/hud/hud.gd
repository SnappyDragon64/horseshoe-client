extends UIWindow


@onready var line_edit: LineEdit = $PanelContainer/MarginContainer/HBoxContainer/LineEdit
@onready var log_panel: Panel = $VBoxContainer/Panel
@onready var chat_log: RichTextLabel = $VBoxContainer/Panel/ScrollContainer/MarginContainer/RichTextLabel


func _ready() -> void:
	ChatManager.log_updated.connect(_on_log_updated)


func _on_log_updated(_formatted_line: String) -> void:
	var history := ChatManager.get_full_log()
	chat_log.set_text(history)
	_scroll_to_bottom.call_deferred()


func _scroll_to_bottom() -> void:
	var scrollbar := chat_log.get_v_scroll_bar()
	scrollbar.value = scrollbar.max_value



func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		_submit_message()
		get_viewport().set_input_as_handled()


func _on_submit_button_pressed() -> void:
	_submit_message()
	line_edit.grab_focus()


func _submit_message() -> void:
	var text: String = line_edit.text
	
	if len(text) > 0:
		ChatManager.player_message(WorldManager.local_player_id, text)
		var packet: Dictionary = PacketBuilder.create_chat_packet(text)
		NetworkManager.send_packet(packet)
		line_edit.clear()


func _on_log_button_pressed() -> void:
	log_panel.set_visible(not log_panel.visible)
	
