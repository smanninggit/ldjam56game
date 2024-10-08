extends Node3D

var bees_in_range = []
var wasps_in_range = []

var target_position
var can_battle = true
var is_moving = false
var close_enough = 2
var wasp_speed = 5
var min_target_distance = 5 

@onready var patrol_area = get_parent().get_child(0).get_child(0)

func _ready():
	wasps_in_range.append(self)
	select_new_target()

func _process(delta: float) -> void:
	if is_moving and can_battle:
		move_to_target(delta)

func move_to_target(delta: float) -> void:
	var direction = target_position - global_transform.origin
	var distance_to_target = direction.length()
	direction = direction.normalized()
	direction.y = 0
	if distance_to_target > close_enough:
		self.global_transform.origin += direction * wasp_speed * delta
		rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta * 4)
	else:
		is_moving = false
		select_new_target()

func select_new_target():
	var extents = patrol_area.shape.extents
	var origin = patrol_area.global_transform.origin
	var x_position = randf_range(-extents.x, extents.x)
	var z_position = randf_range(-extents.z, extents.z)
	target_position = origin + Vector3(x_position, 0, z_position)
	if (target_position - global_transform.origin).length() < min_target_distance:
		select_new_target()
	var wasp_timer = get_tree().create_timer(1)
	await wasp_timer.timeout
	is_moving = true

func _on_area_3d_area_entered(area: Area3D) -> void:
	if can_battle == true:
		var object = area.get_parent()
		if object.is_in_group("selectable"):
			bees_in_range.append(object)
		if object.is_in_group("wasps"):
			wasps_in_range.append(object)


func _on_area_3d_area_exited(area: Area3D) -> void:
	if can_battle == true:
		var object = area.get_parent()
		if object.is_in_group("selectable"):
			if bees_in_range.has(object):
				bees_in_range.erase(object)
		if object.is_in_group("wasps"):
			if wasps_in_range.has(object):
				wasps_in_range.erase(object)


func _on_combat_area_entered(area: Area3D) -> void:
	var object = area.get_parent()
	if object.is_in_group("selectable"):
		if can_battle == true:
			can_battle = false
			Globalresources.initiate_wasp_combat(bees_in_range, wasps_in_range, self)
