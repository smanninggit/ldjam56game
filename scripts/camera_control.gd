extends Node3D

var camera_speed: float = 30.0
var edge_scroll_speed: float = 15.0
var edge_border: float = 50.0
var max_zoom_out: float = 30.0
var max_zoom_in: float = 5.0

var boundary_min = Vector3(-40, 0, -19)
var boundary_max = Vector3(145, 0, 65)

var can_mouse = true

@onready var camera = $Camera3D

func _process(delta):
	handle_keyboard_input(delta)
	handle_mouse_edge_scroll(delta)
	
func handle_keyboard_input(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("keys_up"):
		direction -= transform.basis.z
	if Input.is_action_pressed("ui_down") or Input.is_action_pressed("keys_down"):
		direction += transform.basis.z
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("keys_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("keys_right"): 
		direction += transform.basis.x

	if direction != Vector3.ZERO:
		direction.y = 0 
		var new_position = global_transform.origin + direction.normalized() * camera_speed * delta
		new_position.x = clamp(new_position.x, boundary_min.x, boundary_max.x)
		new_position.z = clamp(new_position.z, boundary_min.z, boundary_max.z)
		global_transform.origin = new_position
		
func handle_mouse_edge_scroll(delta):
	if can_mouse:
		var mouse_pos = get_viewport().get_mouse_position()
		var screen_size = get_viewport().get_size()

		var direction = Vector3.ZERO

		if mouse_pos.x < edge_border:
			direction -= transform.basis.x
		elif mouse_pos.x > screen_size.x - edge_border:
			direction += transform.basis.x

		if mouse_pos.y < edge_border:
			direction -= transform.basis.z
		elif mouse_pos.y > screen_size.y - edge_border:
			direction += transform.basis.z

		if direction != Vector3.ZERO:
			direction.y = 0
			var new_position = global_transform.origin + direction.normalized() * camera_speed * delta
			new_position.x = clamp(new_position.x, boundary_min.x, boundary_max.x)
			new_position.z = clamp(new_position.z, boundary_min.z, boundary_max.z)
			global_transform.origin = new_position
