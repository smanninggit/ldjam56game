extends Control

@onready var bee_name_title: Label = %TileNameTitle
@onready var description_text: Label = %DescriptionText
@onready var speed_text: Label = %SpeedText


func on_selected_changed():
	bee_name_title.text = Globalcontrol.selectedBeeName
	speed_text.text = str(Globalcontrol.selectedBeeSpeed)
	description_text.text = Globalcontrol.selectedBeeDescription
	
