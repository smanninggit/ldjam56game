extends Control
@onready var resource_label: Label = %ResourceLabel
@onready var resource_icon: TextureRect = %ResourceIcon

var actual_floating_text = preload("res://uiscenes/actual_floating_text.tscn")

var message_queue: Array = []
var is_processing_data: bool = false
var message_delay = 0.3

func float_text(message: String, icon: Texture):
	var message_data = {
		"text": message,
		"icon": icon
	}
	message_queue.append(message_data)
	if not is_processing_data:
		process_queue()

func process_queue():
	is_processing_data = true
	while message_queue.size() > 0:
		var current_message = message_queue.pop_front()
		_show_floating_text(current_message)
		var message_timer = get_tree().create_timer(message_delay)
		await message_timer.timeout
	is_processing_data = false

func _show_floating_text(message_data: Dictionary):
	var message_floater = actual_floating_text.instantiate()
	message_floater.get_child(0).get_child(0).text = message_data["text"]
	message_floater.get_child(0).get_child(1).texture = message_data["icon"]
	message_floater.get_child(0).get_child(0).set_size(Vector2(50, 50))
	add_child(message_floater)
	##message_floater.rect_position = Vector2(0, 100)
	
	var tweener = get_tree().create_tween()
	tweener.tween_property(message_floater, "position", message_floater.position + Vector2(0, -650), 4.0).set_trans(Tween.TRANS_LINEAR)
	tweener.tween_property(message_floater, "modulate:a", 0, 2.0).set_trans(Tween.TRANS_LINEAR)
	
	tweener.tween_callback(func():
		if message_floater != null:
			message_floater.queue_free()
	)
