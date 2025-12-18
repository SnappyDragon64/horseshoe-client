extends Node


signal log_updated()
signal bubble_requested(author: String, text: String)

const MAX_HISTORY: int = 100

var _history: Array[String] = []


func player_message(author: String, text: String) -> void:
	var formatted_line := "%s: %s" % [author, text]
	
	_history.push_back(formatted_line)
	
	if _history.size() > MAX_HISTORY:
		_history.pop_front()
		
	log_updated.emit()
	bubble_requested.emit(author, text)


func get_full_log() -> String:
	return "\n".join(_history)


func clear_log() -> void:
	_history.clear()
	log_updated.emit()
