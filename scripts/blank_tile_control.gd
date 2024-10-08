extends Node3D

var cell_name: String = "Empty Cell"
var wax_cost: int
var honey_production: int
var wax_production: int
var description: String = "Placeholder"


func _toggle_selection():
	print("selected one")
	Globalcontrol.select_cell(self)


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_toggle_selection()
