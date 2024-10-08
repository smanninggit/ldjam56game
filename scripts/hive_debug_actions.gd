extends Control

func _on_add_pollen_pressed() -> void:
	Globalresources.add_pollen(10)


func _on_add_wax_pressed() -> void:
	Globalresources.add_wax(10)


func _on_add_honey_pressed() -> void:
	Globalresources.add_honey(10)


func _on_add_eggs_pressed() -> void:
	Globalresources.add_eggs(1)


func _on_add_bees_pressed() -> void:
	Globalresources.add_bees(1)


func _on_add_workers_pressed() -> void:
	Globalresources.add_workers(1)


func _on_add_soldiers_pressed() -> void:
	Globalresources.add_soldiers(1)


func _on_get_medium_pressed() -> void:
	Globalcontrol._deselect_hive()
	Globalcontrol.attain_medium_hive()


func _on_get_large_pressed() -> void:
	Globalcontrol._deselect_hive()
	Globalcontrol.attain_large_hive()
