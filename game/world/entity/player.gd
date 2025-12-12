class_name Player
extends Area2D


var is_local: bool = false:
	get:
		return is_local
	set(value):
		is_local = value
		
		if ring:
			ring.set_visible(is_local)

var player_name: String:
	get:
		return player_name
	set(value):
		player_name = value
		
		if label:
			label.set_text(player_name)

var speed: float = 200.0

@onready var sprite_holder: Node2D = $SpriteHolder
@onready var sprite: Sprite2D = $SpriteHolder/Sprite2D
@onready var ring: Sprite2D = $Ring

@onready var label: Label = $Label

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

@onready var chat_bubble_holder: Control = $ChatBubbleHolder
@onready var chat_bubble: Label = $ChatBubbleHolder/ChatBubble
@onready var chat_bubble_timer: Timer = $ChatBubbleTimer

var walk_tween: Tween
var chat_bubble_tween: Tween


func _ready() -> void:
	label.set_text(player_name)
	ring.set_visible(is_local)
	navigation_agent.navigation_finished.connect(_on_navigation_agent_navigation_finished)


func _process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		return

	var next_position: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_position)
	
	global_position += direction * speed * delta


func _orient_sprite(reference_position: Vector2) -> void:
	var direction: int = sign(reference_position.x - position.x)
	sprite.set_scale(Vector2(direction, 1))


func _reset_sprite_scale() -> void:
	if walk_tween:
		walk_tween.kill()
		
	sprite_holder.set_scale(Vector2.ONE)


func _on_navigation_agent_navigation_finished() -> void:
	_reset_sprite_scale()


func move_to(target_position: Vector2) -> void:
	navigation_agent.target_position = target_position
	_orient_sprite(target_position)
	_reset_sprite_scale()
	
	walk_tween = create_tween()
	walk_tween.set_trans(Tween.TRANS_SINE)
	walk_tween.set_ease(Tween.EASE_IN_OUT)
	walk_tween.tween_property(sprite_holder, ^"scale", Vector2(1.1, 0.9), 0.2)
	walk_tween.set_ease(Tween.EASE_OUT_IN)
	walk_tween.tween_property(sprite_holder, ^"scale", Vector2(1.0, 1.0), 0.2)
	walk_tween.set_loops()


func display_message(message: String) -> void:
	if chat_bubble_tween:
		chat_bubble_tween.kill()
	
	chat_bubble.text = _wrap_text(message, 24)
	
	chat_bubble.modulate = Color.WHITE
	chat_bubble_timer.start()


func _wrap_text(s: String, max_len: int) -> String:
	var out := []
	var line := ""
	
	for w in s.split(" "):
		if w.length() > max_len:
			if line != "":
				out.append(line)
				line = ""
				
			for i in range(0, w.length(), max_len):
				out.append(w.substr(i, max_len))
				
			continue

		if line.length() + w.length() + (0 if line == "" else 1) > max_len:
			out.append(line)
			line = w
		else:
			line = w if line == "" else line + " " + w

	if line != "":
		out.append(line)

	return "\n".join(out)


func _on_chat_bubble_timer_timeout() -> void:
	chat_bubble_tween = create_tween()
	chat_bubble_tween.set_trans(Tween.TRANS_SINE)
	chat_bubble_tween.set_ease(Tween.EASE_IN_OUT)
	chat_bubble_tween.tween_property(chat_bubble, ^"modulate", Color.TRANSPARENT, 1.0)
