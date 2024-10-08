extends Node3D

var is_moving = false
var target_position
var close_enough = 5.0
var bird_speed = 7
var min_target_distance = 5.0 

@onready var patrol_area = get_parent().get_child(1).get_child(0)

func _ready():
	select_new_target()

func _process(delta: float) -> void:
	if is_moving:
		move_to_target(delta)

func move_to_target(delta: float) -> void:
	var direction = target_position - global_transform.origin
	var distance_to_target = direction.length()
	direction = direction.normalized()
	direction.y = 0
	if distance_to_target > close_enough:
		self.global_transform.origin += direction * bird_speed * delta
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
	var bird_timer = get_tree().create_timer(1)
	await bird_timer.timeout
	is_moving = true

func _on_area_3d_area_entered(area: Area3D) -> void:
	var object = area.get_parent()
	if object.is_in_group("selectable"):
		object.queue_free()
		match object.bee_name:
			"Scout":
				Globalresources.remove_honey(3)
			"Worker":
				Globalresources.remove_honey(5)
			"Soldier":
				Globalresources.remove_honey(5)
