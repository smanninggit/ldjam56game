extends Control

func _ready() -> void:
	Engine.time_scale = 0

func _on_button_pressed() -> void:
	Engine.time_scale = 1
	self.visible = false

func _on_button_3_pressed() -> void:
	get_tree().quit(0)


func _on_button_2_pressed() -> void:
	%SettingsMenu.visible = true
