extends CanvasLayer


func _on_login_button_pressed() -> void:
	AuthManager.login($Panel/HBoxContainer/LoginContainer/VBoxContainer/LineEdit.get_text(),
						$Panel/HBoxContainer/LoginContainer/VBoxContainer/LineEdit2.get_text())


func _on_register_button_pressed() -> void:
	AuthManager.register($Panel/HBoxContainer/RegisterContainer/VBoxContainer/LineEdit.get_text(),
							$Panel/HBoxContainer/RegisterContainer/VBoxContainer/LineEdit2.get_text())
