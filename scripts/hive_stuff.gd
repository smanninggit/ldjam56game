extends Node3D

@export var hive_name : String
@export var hive_description : String
@export var hive_status : bool
@export var hive_scene = preload("res://small_hive.tscn")

func _toggle_selection():
	Globalcontrol.select_hive(self)

func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_toggle_selection()
