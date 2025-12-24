class_name HandleSystemMessage
extends Handler


func execute(data: Dictionary) -> void:
	var message: String = data.get("message")
	
	UIStack.push(Registries.UI.POPUP, {
		"title": "System Message",
		"text": message
	})
