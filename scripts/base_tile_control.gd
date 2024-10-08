extends Node3D

@export var cellsIndex: int
var cell_name: String
var wax_cost: int
var honey_production: int
var wax_production: int
var unit_production: int
var production_rate: int
var production_cost: int
var description: String

var honey_timer
var honey_timer_delay
var wax_timer
var wax_timer_delay
var bee_timer
var bee_timer_delay
var worker_timer
var worker_timer_delay
var soldier_timer
var soldier_timer_delay

signal cell_ready

func _ready():
	var keys = Globalcellinfo.cell_info.keys()
	cell_name = Globalcellinfo.cell_info[keys[cellsIndex]]["name"]
	wax_cost = Globalcellinfo.cell_info[keys[cellsIndex]]["wax_cost"]
	description = Globalcellinfo.cell_info[keys[cellsIndex]]["description"]
	if Globalcellinfo.cell_info[keys[cellsIndex]]["honey_production"] != 0:
		honey_production = Globalcellinfo.cell_info[keys[cellsIndex]]["honey_production"]
	if Globalcellinfo.cell_info[keys[cellsIndex]]["wax_production"] != 0:
		honey_production = Globalcellinfo.cell_info[keys[cellsIndex]]["wax_production"]
	if Globalcellinfo.cell_info[keys[cellsIndex]]["wax_production"] != 0:
		wax_production = Globalcellinfo.cell_info[keys[cellsIndex]]["wax_production"]
	if Globalcellinfo.cell_info[keys[cellsIndex]]["production_rate"] != 0:
		production_rate = Globalcellinfo.cell_info[keys[cellsIndex]]["production_rate"]
	if Globalcellinfo.cell_info[keys[cellsIndex]]["production_cost"] != 0:
		production_cost = Globalcellinfo.cell_info[keys[cellsIndex]]["production_cost"]
	if Globalcellinfo.cell_info[keys[cellsIndex]]["unit_producation"] != 0:
		unit_production = Globalcellinfo.cell_info[keys[cellsIndex]]["unit_producation"]
	cell_ready.emit()
	emit_signal("cell_ready")
	print(cell_name)
	if cell_name == "Honey Production":
		start_honey_production()
	if cell_name == "Wax Production":
		start_wax_production()
	if cell_name == "Nursery":
		start_bee_production()
	if cell_name == "Soldier Training":
		print("me!")
		start_soldier_production()
	if cell_name == "Worker Training":
		start_worker_production()

func _toggle_selection():
	Globalcontrol.select_cell(self)


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_toggle_selection()

func start_honey_production():
	honey_timer_delay = production_rate
	if Globalresources.current_pollen > production_cost:
		Globalresources.remove_pollen(production_cost)
		honey_timer = get_tree().create_timer(honey_timer_delay)
		await honey_timer.timeout
		Globalresources.add_honey(honey_production)
		start_honey_production()
	else:
		print("why?")
		Globalresources.handle_floating_resource("Not enough pollen.\nCannot make honey.", Globalresources.icons[0])
		honey_timer = get_tree().create_timer(honey_timer_delay)
		await honey_timer.timeout
		start_honey_production()
		
func start_wax_production():
	wax_timer_delay = production_rate
	if Globalresources.current_pollen > production_cost:
		Globalresources.remove_pollen(production_cost)
		wax_timer = get_tree().create_timer(wax_timer_delay)
		await wax_timer.timeout
		Globalresources.add_wax(wax_production)
		start_wax_production()
	else:
		Globalresources.handle_floating_resource("Not enough pollen.\nCannot make wax.", Globalresources.icons[1])
		wax_timer = get_tree().create_timer(wax_timer_delay)
		await wax_timer.timeout
		start_wax_production()

func start_bee_production():
	bee_timer_delay = production_rate
	if Globalresources.current_eggs > production_cost:
		Globalresources.remove_eggs(production_cost)
		bee_timer = get_tree().create_timer(bee_timer_delay)
		await bee_timer.timeout
		Globalresources.add_bees(unit_production)
		start_bee_production()
	else:
		Globalresources.handle_floating_resource("Not enough eggs.\nCannot make bee.", Globalresources.icons[1])
		bee_timer = get_tree().create_timer(bee_timer_delay)
		await bee_timer.timeout
		start_bee_production()
	
func start_worker_production():
	worker_timer_delay = production_rate
	if Globalresources.current_bees > production_cost:
		Globalresources.remove_bees(production_cost)
		worker_timer = get_tree().create_timer(worker_timer_delay)
		await worker_timer.timeout
		Globalresources.add_workers(unit_production)
		start_worker_production()
	else:
		Globalresources.handle_floating_resource("Not enough bees.\nCannot make worker.", Globalresources.icons[1])
		worker_timer = get_tree().create_timer(worker_timer_delay)
		await worker_timer.timeout
		start_worker_production()

func start_soldier_production():
	print("starting soldier production")
	soldier_timer_delay = production_rate
	if Globalresources.current_bees > production_cost:
		Globalresources.remove_bees(production_cost)
		soldier_timer = get_tree().create_timer(soldier_timer_delay)
		await soldier_timer.timeout
		Globalresources.add_soldiers(unit_production)
		start_soldier_production()
	else:
		Globalresources.handle_floating_resource("Not enough bees.\nCannot make soldier.", Globalresources.icons[1])
		soldier_timer = get_tree().create_timer(soldier_timer_delay)
		await soldier_timer.timeout
		start_soldier_production()
