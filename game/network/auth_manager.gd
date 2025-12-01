extends Node


signal login_success
signal login_failed(error_message: String)
signal register_success
signal register_failed(error_message: String)

const SESSION_PATH = "user://session.cfg"

var api_url: String = "http://localhost:8080" if false else ProjectSettings.get_setting("application/config/api_url")

var current_token: String = ""
var current_username: String = ""

var _http_login: HTTPRequest
var _http_register: HTTPRequest


func _ready() -> void:
	_http_login = HTTPRequest.new()
	add_child(_http_login)
	_http_login.request_completed.connect(_on_login_completed)

	_http_register = HTTPRequest.new()
	add_child(_http_register)
	_http_register.request_completed.connect(_on_register_completed)


func login(username: String, password: String) -> void:
	var url := api_url + "/login"
	var headers := ["Content-Type: application/json"]
	var body := JSON.stringify({"username": username, "password": password})
	
	var error := _http_login.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		login_failed.emit("Internal Error: Could not send request.")


func register(username: String, password: String) -> void:
	var url := api_url + "/register"
	var headers := ["Content-Type: application/json"]
	var body := JSON.stringify({"username": username, "password": password})
	
	var error := _http_register.request(url, headers, HTTPClient.METHOD_POST, body)
	if error != OK:
		register_failed.emit("Internal Error: Could not send request.")


func save_session() -> void:
	var config := ConfigFile.new()
	config.set_value("auth", "token", current_token)
	config.set_value("auth", "username", current_username)
	config.save(SESSION_PATH)


func load_session() -> bool:
	var config := ConfigFile.new()
	var err := config.load(SESSION_PATH)
	
	if err == OK:
		current_token = config.get_value("auth", "token", "")
		current_username = config.get_value("auth", "username", "")
		return current_token != ""
	
	return false


func clear_session() -> void:
	current_token = ""
	current_username = ""
	var dir := DirAccess.open("user://")
	dir.remove(SESSION_PATH)


func _on_login_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json: Dictionary = JSON.parse_string(body.get_string_from_utf8())
		if json:
			current_token = json.get("token", "")
			current_username = json.get("username", "")
			save_session()
			login_success.emit()
		else:
			login_failed.emit("Invalid server response.")
	elif response_code == 401:
		login_failed.emit("Invalid username or password.")
	else:
		login_failed.emit("Server Error: %d" % response_code)


func _on_register_completed(_result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if response_code == 200:
		register_success.emit()
	elif response_code == 409:
		register_failed.emit("Username already taken.")
	else:
		register_failed.emit("Registration failed: %d" % response_code)
