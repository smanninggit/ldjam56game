extends MarginContainer

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var button: Button = $HBoxContainer/Button

func set_names(icon, bee_name):
	texture_rect.texture = icon
	button.text = bee_name


func _on_button_pressed() -> void:
	var parent = get_parent()
	var children = parent.get_children()
	for i in range(children.size()):
		if children[i] == self:
			Globalcontrol.select_bee(Globalcontrol.currentlySelectedBees[i])
			
