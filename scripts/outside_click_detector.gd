extends StaticBody3D


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			Globalcontrol._deselect_bee()
			Globalcontrol._deselect_bees()
			Globalcontrol._deselect_tree()
			Globalcontrol._deselect_hive()
