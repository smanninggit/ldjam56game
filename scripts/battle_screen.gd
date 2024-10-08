extends Control

@onready var bee_strength_value: Label = %BeeStrengthValue
@onready var wasp_strength_value: Label = %WaspStrengthValue
@onready var outcome: Label = %Outcome
@onready var bee_roll: Label = %BeeRoll
@onready var wasp_roll: Label = %WaspRoll
@onready var exit_battle: Button = %ExitBattle


func set_army_values(bee_strength, wasp_strength):
	bee_strength_value.text = str(bee_strength)
	wasp_strength_value.text = str(wasp_strength)

func set_roll_values(bee_roll_value, wasp_roll_value):
	bee_roll.text = ("Roll: " + str(bee_roll_value))
	wasp_roll.text = ("Roll: " + str(wasp_roll_value))
	
func set_outcome(winner_string, bee_total, wasp_total):
	outcome.text = (winner_string + "\nBee Total: " + str(bee_total) + "\nWasp Total: " + str(wasp_total))


func _on_exit_battle_pressed() -> void:
	self.visible = false
