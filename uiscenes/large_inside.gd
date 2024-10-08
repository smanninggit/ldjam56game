extends Control



func _on_unlock_pressed() -> void:
	Globalcontrol.switch_to_outside()
	Globalcontrol.attain_large_hive()
	self.visible = false


func _on_postpone_pressed() -> void:
	self.visible = false
	var bird_timer = get_tree().create_timer(60)
	await bird_timer.timeout
	self.visible = true
