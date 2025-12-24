class_name HandleSystemMessage
extends Handler


func execute(data: Dictionary) -> void:
	var message: String = data.get("message")
	
	UIManager.push(Registries.UI.POPUP, {
		"title": "System Message",
		"text": message
	})
