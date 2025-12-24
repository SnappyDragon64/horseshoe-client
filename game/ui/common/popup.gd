extends UIView


@onready var title_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var text_label: Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/TextLabel
@onready var button: Button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Button

var title: String = "Title":
	get:
		return title
	set(value):
		title = value
		
		if title_label:
			title_label.set_text(title)

var text: String = "Text":
	get:
		return text
	set(value):
		text = value
		
		if text_label:
			text_label.set_text(text)

var button_text: String = "OK":
	get:
		return button_text
	set(value):
		button_text = value
		
		if button:
			button.set_text(button_text)


func _ready() -> void:
	title_label.set_text(title)
	text_label.set_text(text)
	button.set_text(button_text)
	
	button.pressed.connect(close)


func grab_default_focus() -> void:
	if button:
		button.grab_focus()
