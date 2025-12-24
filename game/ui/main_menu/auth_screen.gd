extends UIWindow


func _ready() -> void:
	SessionManager.login_failed.connect(_on_login_failed)
	SessionManager.register_failed.connect(_on_register_failed)
	SessionManager.register_success.connect(_on_register_success)


func _on_login_button_pressed() -> void:
	SessionManager.login($Panel/HBoxContainer/LoginContainer/VBoxContainer/LineEdit.get_text(),
						$Panel/HBoxContainer/LoginContainer/VBoxContainer/LineEdit2.get_text())


func _on_register_button_pressed() -> void:
	SessionManager.register($Panel/HBoxContainer/RegisterContainer/VBoxContainer/LineEdit.get_text(),
							$Panel/HBoxContainer/RegisterContainer/VBoxContainer/LineEdit2.get_text())


func _on_login_failed(error_msg: String) -> void:
	UIManager.push(Registries.UI.POPUP, {
		"title": "Login Failed",
		"text": error_msg
	})


func _on_register_failed(error_msg: String) -> void:
	UIManager.push(Registries.UI.POPUP, {
		"title": "Registration Failed",
		"text": error_msg
	})


func _on_register_success() -> void:
	UIManager.push(Registries.UI.POPUP, {
		"title": "Success",
		"text": "Account created! You can now log in."
	})
