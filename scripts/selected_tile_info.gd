extends Control

@onready var tile_name_title: Label = %TileNameTitle
@onready var description_text: Label = %DescriptionText


func on_selected_changed():
	tile_name_title.text = Globalcontrol.selectedCellName
	description_text.text = Globalcontrol.selectedCellDescription
	
