extends Node3D

@export var beeIndex: int
var bee_name: String
var bee_speed: int
var bee_ability: String
var description: String
var bee_value: int

enum BeeState {
	MOVING_TO_RESOURCE,
	HARVESTING,
	MOVING_TO_HIVE,
	DONE
}

var current_state = BeeState.DONE

var is_moving: bool = false
var is_harvesting: bool = false
var target_position: Vector3
var close_enough: float = 0.5

var resource_target
var hive_target
var resource_resources

signal bee_ready

func _ready():
	var keys = Globalcellinfo.bee_info.keys()
	bee_name = Globalcellinfo.bee_info[keys[beeIndex]]["name"]
	bee_speed = Globalcellinfo.bee_info[keys[beeIndex]]["speed"]
	bee_ability = Globalcellinfo.bee_info[keys[beeIndex]]["ability"]
	description = Globalcellinfo.bee_info[keys[beeIndex]]["description"]
	bee_value = get_bee_value()
	bee_ready.emit()
	emit_signal("bee_ready")

func get_bee_value() -> int:
	match bee_name:
		"Scout":
			return 1
		"Worker":
			return 2
		"Soldier":
			return 4
		_:
			return 0

func _process(delta: float) -> void:
	if is_moving:
		move_to_target(delta)

func _input(event: InputEvent) -> void:
	if Globalcontrol.currentlySelectedBee == self or Globalcontrol.currentlySelectedBees.has(self):
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var mouse_position = event.position
				var camera = get_viewport().get_camera_3d()
				var from = camera.project_ray_origin(mouse_position)
				var to = from + camera.project_ray_normal(mouse_position) * 50
				var space_state = get_world_3d().direct_space_state
				var ray_parameters = PhysicsRayQueryParameters3D.create(from, to)
				var result = space_state.intersect_ray(ray_parameters)
			
				if result:
					if result.collider.name == "ResourceBody":
						if bee_name == "Worker":
							if result.collider.get_parent().remaining_resources != 0:
								start_pollen_harvest(result.collider)
						else:
							Globalresources.handle_floating_resource("Only Workers can harvest", Globalresources.icons[4])
					else:
						if is_harvesting:
							is_harvesting = false
						target_position = result.position
						is_moving = true

func move_to_target(delta: float) -> void:
	if is_harvesting == false:
		var direction = (target_position - global_transform.origin).normalized()
		direction.y = 0
		if direction.length() > close_enough:
			self.global_transform.origin += direction * bee_speed * delta
			rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta * 4)
		else:
			is_moving = false
	else:
		match current_state:
			BeeState.MOVING_TO_RESOURCE:
				var direction
				direction = (resource_target.global_transform.origin - global_transform.origin).normalized()
				direction.y = 0
				if direction.length() > close_enough:
					self.global_transform.origin += direction * bee_speed * delta
					rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta * 4)
				else:
					if resource_target.remaining_resources > 0:
						print("remaining:" + str(resource_target.remaining_resources))
						resource_target._collect_resources()
						current_state = BeeState.MOVING_TO_HIVE
					else:
						current_state = BeeState.DONE
						is_moving = false
						is_harvesting = false
						Globalresources.handle_floating_resource("Resource node empty.", Globalresources.icons[0])

			BeeState.MOVING_TO_HIVE:
				var hive_direction = (hive_target.global_transform.origin - global_transform.origin).normalized()
				hive_direction.y = 0
				if hive_direction.length() > close_enough:
					self.global_transform.origin += hive_direction * bee_speed * delta
					rotation.y = lerp_angle(rotation.y, atan2(hive_direction.x, hive_direction.z), delta * 4)
				else:
					Globalresources.add_pollen(5) 
					current_state = BeeState.MOVING_TO_RESOURCE

			BeeState.DONE:
				is_moving = false
				is_harvesting = false
					
func start_pollen_harvest(resource_node: StaticBody3D):
	hive_target = Globalresources.hive_1_target
	resource_target = resource_node.get_parent()
	resource_resources = resource_target.remaining_resources
	if resource_resources > 0:
		current_state = BeeState.MOVING_TO_RESOURCE
		if Globalresources.first_harvest == false:
			Globalresources.bee_tut_label.visible = false
			Globalresources.first_harvest = true
		is_moving = true
		is_harvesting = true
	else:
		Globalresources.handle_floating_resource("Resource node empty.", Globalresources.icons[0])

func _toggle_selection():
	Globalcontrol.select_bee(self)

func _add_selection():
	Globalcontrol.select_another_bee(self)

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and !Input.is_key_pressed(KEY_SHIFT):
			print("this")
			_toggle_selection()
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT and Input.is_key_pressed(KEY_SHIFT):
			print('this other')
			_add_selection()
