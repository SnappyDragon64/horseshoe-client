extends Panel


func _on_login_button_pressed() -> void:
	AuthManager.login($HBoxContainer/LoginContainer/VBoxContainer/LineEdit.get_text(),
						$HBoxContainer/LoginContainer/VBoxContainer/LineEdit2.get_text())


func _on_register_button_pressed() -> void:
	AuthManager.register($HBoxContainer/RegisterContainer/VBoxContainer/LineEdit.get_text(),
						$HBoxContainer/RegisterContainer/VBoxContainer/LineEdit2.get_text())
