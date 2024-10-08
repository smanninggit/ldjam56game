extends Control

@onready var pollen_amount: Label = %PollenAmount


func on_selected_changed():
	pollen_amount.text = str(Globalcontrol.treeRemainingResources)
