extends MarginContainer

@onready var button: Button = $Button
@onready var key: Label = $Key

@export var image_icons: Array[Texture] = []

var iconImage: Texture
var myIndex

var popup_information = preload("res://uiscenes/place_bee_mouseover.tscn")
var popup_instance = null

var key_mapping = {
	0: KEY_1,
	1: KEY_2,
	2: KEY_3,
}


func _ready() -> void:
	var parent_node = get_parent()
	
	for i in range(parent_node.get_child_count()):
		if parent_node.get_child(i) == self:
			myIndex = i
			key.text = str(i + 1)
			iconImage = image_icons[i]
			button.icon = iconImage
			break

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if Input.is_key_pressed(key_mapping[myIndex]):
			_on_button_pressed()
			

func _on_button_pressed() -> void:
	if Globalcontrol.is_outside:
		var keys = Globalcellinfo.bee_info.keys()
		var bee_name = Globalcellinfo.bee_info[keys[myIndex]]["name"]
		print(bee_name)
		match bee_name:
			"Scout":
				Globalresources.place_scout()
			"Worker":
				Globalresources.place_worker()
			"Soldier":
				Globalresources.place_soldier()


func _on_button_mouse_entered() -> void:
	if popup_instance == null:
		popup_instance = popup_information.instantiate()
		add_child(popup_instance)
		popup_instance.call_deferred("set_position", Vector2(0, -215))
		var keys = Globalcellinfo.bee_info.keys()
		popup_instance.bee_name_label.text = Globalcellinfo.bee_info[keys[myIndex]]["name"]
		popup_instance.bee_speed.text = str(Globalcellinfo.bee_info[keys[myIndex]]["speed"])
		popup_instance.bee_ability.text = str(Globalcellinfo.bee_info[keys[myIndex]]["ability"])
		popup_instance.description_text.text = Globalcellinfo.bee_info[keys[myIndex]]["description"]


func _on_button_mouse_exited() -> void:
	if get_child(2) != null:
		get_child(2).queue_free()
