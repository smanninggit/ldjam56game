extends Node3D

@export var flower_bed: MeshInstance3D

var collection_amount = 5
var resource_amount = 50
var remaining_resources
var resource_title = "Flowers"
var resource_description = "A small patch of flowers. Worker bees can collect pollen from here."

func _ready():
	remaining_resources = resource_amount

func _toggle_selection():
	Globalcontrol.select_resource(self)

func _collect_resources():
	remaining_resources -= collection_amount
	if remaining_resources < 0:
		remaining_resources = 0 
	if remaining_resources == 0:
		flower_bed.visible = false
	if Globalcontrol.currentlySelectedTree == self:
		Globalcontrol.treeRemainingResources = remaining_resources
		print(Globalcontrol.treeRemainingResources)
		Globalcontrol.tree_info_ui.on_selected_changed()


func _on_static_body_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_toggle_selection()
