extends Control

var previous_db

@onready var check_box: CheckBox = %CheckBox

func _ready():
	%MusicSlider.value= db_to_linear(AudioServer.get_bus_volume_db(1))
	%VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	
func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, 
	linear_to_db(value))
	

func _on_mute_check_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), toggled_on)


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, 
	linear_to_db(value))



func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_button_pressed() -> void:
	self.visible = false


func _on_check_box_toggled(toggled_on: bool) -> void:
	var nodes_in_camcontrols = get_tree().get_nodes_in_group("camcontrol")
	var cam_controls = nodes_in_camcontrols[0]
	if toggled_on == true:
		cam_controls.can_mouse = true
	else:
		cam_controls.can_mouse = false
	
