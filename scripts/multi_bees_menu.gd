extends Control

var cool_names = [
	"Billy",
	"Weener",
	"Klunk",
	"Pidge",
	"Snizzle",
	"Cloghopper",
	"Noggin",
	"Nadger",
	"Snuffit",
	"Wilf",
	"Bosnia",
	"Calvin",
	"Kelvin",
	"Nogbert",
	"Satch",
	"Horatio",
	"Whelk",
	"Beany",
	"Flump",
	"Sass",
	"Stumpy",
	"Pinkie",
]

var multi_bees = []

@onready var v_box_container: VBoxContainer = %VBoxContainer
var each_bee_ui = preload("res://uiscenes/each_bee_ui.tscn")
func add_a_bee(bee_name):
	print("Adding a bee")
	var icon
	match bee_name:
		"Scout":
			icon = Globalresources.icons[3]
		"Worker":
			icon = Globalresources.icons[4]
		"Soldier":
			icon = Globalresources.icons[5]
	var newbee = each_bee_ui.instantiate()
	v_box_container.add_child(newbee)
	multi_bees.append(newbee)
	newbee.set_names(icon, get_cool_name())

func clear_bees():
	for object in v_box_container.get_children():
		object.queue_free()


func get_cool_name() -> String:
	var random_index = randi() % cool_names.size()
	return cool_names[random_index]
