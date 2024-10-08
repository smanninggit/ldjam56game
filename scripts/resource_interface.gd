extends Control


@onready var current_pollen: Label = %PollenAmount
@onready var current_wax: Label = %WaxAmount
@onready var max_wax: Label = %WaxMax
@onready var current_honey: Label = %HoneyAmount
@onready var max_honey: Label = %HoneyMax
@onready var current_bees: Label = %BeesAmount
@onready var current_workers: Label = %WorkersAmount
@onready var current_soldiers: Label = %SoldiersAmount
@onready var current_eggs: Label = %EggsAmount

@onready var bees_max: Label = %BeesMax
@onready var workers_max: Label = %WorkersMax
@onready var soldiers_max: Label = %SoldiersMax


signal im_ready

func _ready():
	emit_signal("im_ready")
	
func update_maxes(new_maxes):
	bees_max.text = str(new_maxes)
	workers_max.text = str(new_maxes)
	soldiers_max.text = str(new_maxes)
