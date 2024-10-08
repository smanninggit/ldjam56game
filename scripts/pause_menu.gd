extends Control



func _input(event):
	if %MainMenu.visible == false:
		if event is InputEventKey and event.pressed and Input.is_action_pressed("ui_cancel") and %SettingsMenu.visible == false:
			toggle_pause_menu()

func toggle_pause_menu():
	if self.is_visible():
		self.hide()
	else:
		self.show()

func _on_resume_pressed() -> void:
	self.visible = false


func _on_settings_pressed() -> void:
	%SettingsMenu.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit(0)


func _on_main_menu_pressed() -> void:
	get_tree().reload_current_scene()
	Globalresources.reset_me()
	Globalcontrol.reset_me()
