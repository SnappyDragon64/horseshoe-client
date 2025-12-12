extends UIWindow


var close_on: Signal


func _ready() -> void:
	if close_on:
		close_on.connect(close, CONNECT_ONE_SHOT | CONNECT_DEFERRED)
