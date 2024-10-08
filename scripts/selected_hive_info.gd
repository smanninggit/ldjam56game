extends Control

@onready var tile_name_title: Label = %TileNameTitle
@onready var status_text: Label = %StatusText
@onready var description_text: Label = %DescriptionText
@onready var button: Button = %Button


func on_selected_changed():
	tile_name_title.text = Globalcontrol.hiveName
	if (Globalcontrol.hiveStatus == true):
		status_text.text = "Unlocked"
		button.disabled = false
	else:
		status_text.text = "Locked"
		button.disabled = true
	description_text.text = Globalcontrol.hiveDescription


func _on_button_pressed() -> void:
	Globalcontrol.switch_to_hive()
