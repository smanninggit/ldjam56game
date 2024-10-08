class_name GlobalResources
extends Node3D

@onready var ui_node: Node3D = get_tree().root.get_node("Node3D/UI")
@onready var resource_ui: Control = get_tree().root.get_node("Node3D/UI/ResourceInterface")
@onready var ui_floater: Control = get_tree().root.get_node("Node3D/UI/FloatingResourceText")
@onready var failure_screen: Control = get_tree().root.get_node("Node3D/UI/FailureScreen")


var hive_1_target = null

var already_unlocked_medium = false
var already_unlocked_large = false

var stage_1_bee_cap = 10
var stage_2_bee_cap = 20
var stage_3_bee_cap = 20000

var bee_cap = 10

var resource_floating = preload("res://uiscenes/floating_resource_text.tscn")

var icons = [
	preload("res://uiassets/icons/Honey_Drop_Icon.png"),
	preload("res://uiassets/icons/Wax_Bars_Icon.png"),
	preload("res://uiassets/icons/Egg_Icon.png"),
	preload("res://uiassets/icons/Scout_Icon.png"),
	preload("res://uiassets/icons/Worker_Icon.png"),
	preload("res://uiassets/icons/Soldier_Icon.png"),
	preload("res://uiassets/icons/Soldier_Tile_Icon.png"),
	preload("res://uiassets/icons/Worker_Tile_Icon.png"),
	preload("res://uiassets/icons/Pollen_Icon.png"),
]

var current_hive = 0
var bee_selection = null
var scout_bee = preload("res://models/bees/scout_bee.tscn")
var worker_bee = preload("res://models/bees/worker_bee.tscn")
var soldier_bee = preload("res://models/bees/soldier_bee.tscn")

var wasp_value = 6
var first_harvest = false
var max_amount: int = 99999

var honey_storage_add: int = 20
var wax_storage_add: int = 20

var current_pollen: int
var current_wax: int
var current_honey: int
var current_bees: int
var current_eggs: int
var current_workers: int
var current_soldiers: int
var bee_tut_label

var work_num = 0

var current_honey_producers: int
var current_wax_producers: int
var current_worker_producers: int
var current_soldier_producers: int
var current_nurseries: int

var current_max_honey: int
var current_max_wax: int

var base_max_honey: int = 50
var base_max_wax: int = 50

var queen_timer
var queen_egg_delay: int = 10
var egg_amount: int = 1

var battle_screen_ui
var first_scout = false
var first_work = false
var first_bee = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_max_honey = base_max_honey
	current_max_wax	= base_max_wax
	current_honey = 20
	current_wax = 50
	current_pollen = 0
	current_soldiers = 0
	current_eggs = 0
	current_bees = 0
	current_workers = 0
	current_worker_producers = 0
	current_soldier_producers = 0
	current_honey_producers = 0
	current_wax_producers = 0
	current_nurseries = 0
	current_hive = 0
	bee_selection = null
	hive_1_target = null
	var nodes_in_beetut = get_tree().get_nodes_in_group("beetut")
	bee_tut_label = nodes_in_beetut[0]
	if get_tree().current_scene.name == "Node3D":
		resource_ui.im_ready.connect(update_resource_ui)
		call_deferred("queen_lay_eggs")

func reset_producers():
	current_worker_producers = 0
	current_soldier_producers = 0
	current_honey_producers = 0
	current_wax_producers = 0
	current_nurseries = 0

func reset_me():
	current_max_honey = base_max_honey
	current_max_wax	= base_max_wax
	current_honey = 20
	current_wax = 50
	current_pollen = 0
	current_soldiers = 0
	current_eggs = 0
	current_bees = 0
	current_workers = 0
	current_worker_producers = 0
	current_soldier_producers = 0
	current_honey_producers = 0
	current_wax_producers = 0
	current_nurseries = 0
	current_hive = 0
	bee_selection = null
	hive_1_target = null
	resource_ui.im_ready.connect(update_resource_ui)
	call_deferred("queen_lay_eggs")
		
func place_a_bee():
	if Globalcontrol.is_outside:
		if current_hive == 0:
			if _can_spawn_bee():
				var spawn_area = get_tree().root.get_node("Globalcontrol/Node3D/Hive1Area/Area1Collider")
				var extents = spawn_area.shape.extents
				var origin = spawn_area.global_transform.origin
				var x_position = randf_range(-extents.x, extents.x)
				var z_position = randf_range(-extents.z, extents.z)
				var new_bee = bee_selection.instantiate()
				var bee_position = origin + Vector3(x_position, 0, z_position)
				var bee_spawner = get_tree().root.get_node("Globalcontrol/Node3D/BeeList")
				bee_spawner.add_child(new_bee)
				new_bee.global_transform.origin = Vector3(bee_position.x, 3, bee_position.z)
		if current_hive == 1:
			if _can_spawn_bee():
				var nodes_in_hive2 = get_tree().get_nodes_in_group("hive2spawn")
				var spawn_area = nodes_in_hive2[0]
				var extents = spawn_area.shape.extents
				var origin = spawn_area.global_transform.origin
				var x_position = randf_range(-extents.x, extents.x)
				var z_position = randf_range(-extents.z, extents.z)
				var new_bee = bee_selection.instantiate()
				var bee_position = origin + Vector3(x_position, 0, z_position)
				var bee_spawner = get_tree().root.get_node("Globalcontrol/Node3D/BeeList")
				bee_spawner.add_child(new_bee)
				new_bee.global_transform.origin = Vector3(bee_position.x, 3, bee_position.z)
		if current_hive == 2:
			if _can_spawn_bee():
				var nodes_in_hive3 = get_tree().get_nodes_in_group("hive3spawn")
				var spawn_area = nodes_in_hive3[0]
				var extents = spawn_area.shape.extents
				var origin = spawn_area.global_transform.origin
				var x_position = randf_range(-extents.x, extents.x)
				var z_position = randf_range(-extents.z, extents.z)
				var new_bee = bee_selection.instantiate()
				var bee_position = origin + Vector3(x_position, 0, z_position)
				var bee_spawner = get_tree().root.get_node("Globalcontrol/Node3D/BeeList")
				bee_spawner.add_child(new_bee)
				new_bee.global_transform.origin = Vector3(bee_position.x, 3, bee_position.z)

func _can_spawn_bee() -> bool:
	match bee_selection:
		scout_bee:
			if current_bees >= 1:
				remove_bees(1)
				return true
			else:
				handle_floating_resource("Cannot Spawn.\nNot enough bees.", icons[3])
				bee_selection = null
				return false
		worker_bee:
			if current_workers >= 1:
				remove_workers(1)
				return true
			else:
				handle_floating_resource("Cannot Spawn.\nNot enough workers.", icons[4])
				bee_selection = null
				return false
		soldier_bee:
			if current_soldiers >= 1:
				remove_soldiers(1)
				return true
			else:
				handle_floating_resource("Cannot Spawn.\nNot enough soldiers.", icons[5])
				bee_selection = null
				return false
		_:
			return false

func unlock_medium():
	var nodes_in_medium_outside = get_tree().get_nodes_in_group("mediumoutside")
	var medium_hive_outside_unlock_menu = nodes_in_medium_outside[0]
	var nodes_in_medium_inside = get_tree().get_nodes_in_group("mediuminside")
	var medium_hive_inside_unlock_menu = nodes_in_medium_inside[0]
	if Globalcontrol.is_outside == false:
		medium_hive_inside_unlock_menu.visible = true
	else:
		medium_hive_outside_unlock_menu.visible = true
		
func unlock_large():
	var nodes_in_large_outside = get_tree().get_nodes_in_group("largeoutside")
	var large_hive_outside_unlock_menu = nodes_in_large_outside[0]
	var nodes_in_large_inside = get_tree().get_nodes_in_group("largeinside")
	var large_hive_inside_unlock_menu = nodes_in_large_inside[0]
	if Globalcontrol.is_outside == false:
		large_hive_inside_unlock_menu.visible = true
	else:
		large_hive_outside_unlock_menu.show
		

func queen_lay_eggs():
	queen_timer = get_tree().create_timer(queen_egg_delay)
	await queen_timer.timeout
	add_eggs(egg_amount)
	queen_lay_eggs()
	
	
func update_resource_ui():
	if resource_ui:
		resource_ui.max_honey.text = str(current_max_honey)
		resource_ui.max_wax.text = str(current_max_wax)
		resource_ui.current_honey.text = str(current_honey)
		resource_ui.current_pollen.text = str(current_pollen)
		resource_ui.current_wax.text = str(current_wax)
		resource_ui.current_soldiers.text = str(current_soldiers)
		resource_ui.current_workers.text = str(current_workers)
		resource_ui.current_eggs.text =  str(current_eggs)
		resource_ui.current_bees.text = str(current_bees)
	

func add_honey_storage():
	current_max_honey += honey_storage_add
	resource_ui.max_honey.text = str(current_max_honey)

func add_wax_storage():
	current_max_wax += wax_storage_add
	resource_ui.max_wax.text = str(current_max_wax)

func add_honey(amount):
	if ((current_honey + amount) <= current_max_honey):
		current_honey = clamp(current_honey + amount, 0, current_max_honey)
		resource_ui.current_honey.text = str(current_honey)
		handle_floating_resource("+" + str(amount), icons[0])
	else:
		if ((current_honey + amount) > current_max_honey):
			var remainder =  current_max_honey - current_honey
			if remainder == 0:
				handle_floating_resource("Max honey reached.\nAdd more storage.", icons[0])
			else:
				current_honey = clamp(current_honey + remainder, 0, current_max_honey)
				resource_ui.current_honey.text = str(current_honey)
				handle_floating_resource("+" + str(remainder), icons[0])	

func remove_honey(amount):
	current_honey = clamp(current_honey - amount, 0, max_amount)
	resource_ui.current_honey.text = str(current_honey)
	handle_floating_resource("-" + str(amount), icons[0])
	if current_honey <= 0:
		prepare_failure()

func prepare_failure():
	handle_floating_resource("Out of honey.\n Hive will starve.", icons[0])
	var failure_timer = get_tree().create_timer(5)
	await failure_timer.timeout
	if current_honey <= 0:
		failure_screen.visible = true
		Engine.time_scale = 0
	else:
		handle_floating_resource("Starvation avoided!\n Good job!", icons[0])

func add_wax(amount):
	if ((current_wax + amount) <= current_max_wax):
		current_wax = clamp(current_wax + amount, 0, current_max_wax)
		resource_ui.current_wax.text = str(current_wax)
		handle_floating_resource("+" + str(amount), icons[1])
	else:
		if ((current_wax + amount) > current_max_wax):
			var remainder = current_max_wax - current_wax
			if remainder == 0:
				handle_floating_resource("Max wax reached.\nAdd more storage.", icons[1])
			else:
				current_wax = clamp(current_wax + remainder, 0, current_max_wax)
				resource_ui.current_wax.text = str(current_wax)
				handle_floating_resource("+" + str(remainder), icons[1])
	if current_wax >= 100 && already_unlocked_medium == false:
		unlock_medium()
		already_unlocked_medium = true
	if current_wax >= 300 && current_hive == 1 && already_unlocked_large == false:
		unlock_large()
		already_unlocked_large = true
	if current_wax >= 1000 && current_hive == 2:
		var nodes_in_winner = get_tree().get_nodes_in_group("wingame")
		var win_game_menu = nodes_in_winner[0]
		win_game_menu.visible = true
		Engine.time_scale = 0

func remove_wax(amount):
	current_wax = clamp(current_wax - amount, 0, max_amount)
	resource_ui.current_wax.text = str(current_wax)
	handle_floating_resource("-" + str(amount), icons[1])
	
func add_pollen(amount):
	current_pollen = clamp(current_pollen + amount, 0, max_amount)
	resource_ui.current_pollen.text = str(current_pollen)
	handle_floating_resource("+" + str(amount), icons[8])

func remove_pollen(amount):
	current_pollen = clamp(current_pollen - amount, 0, max_amount)
	resource_ui.current_pollen.text = str(current_pollen)
	handle_floating_resource("-" + str(amount), icons[8])
	
func add_eggs(amount):
	current_eggs = clamp(current_eggs + amount, 0, max_amount)
	resource_ui.current_eggs.text =  str(current_eggs)
	handle_floating_resource("+" + str(amount), icons[2])

func remove_eggs(amount):
	current_eggs = clamp(current_eggs - amount, 0, max_amount)
	resource_ui.current_eggs.text =  str(current_eggs)
	handle_floating_resource("-" + str(amount), icons[2])
	

func update_max_bees():
	print("Should happen")
	if current_hive == 1:
		resource_ui.update_maxes(stage_2_bee_cap)
	if current_hive == 2:
		resource_ui.update_maxes(stage_3_bee_cap)

func add_soldiers(amount):
	if ((current_soldiers + amount) <= bee_cap):
		current_soldiers = clamp(current_soldiers + amount, 0, bee_cap)
		resource_ui.current_soldiers.text = str(current_soldiers)
		handle_floating_resource("+" + str(amount), icons[5])
	else:
		if ((current_soldiers + amount) > bee_cap):
			var remainder = bee_cap - current_soldiers
			if remainder == 0:
				handle_floating_resource("Max soldiers reached.\nUpgrade hive for more.", icons[5])
			else:
				current_soldiers = clamp(current_soldiers + remainder, 0, bee_cap)
				resource_ui.current_soldiers.text = str(current_soldiers)
				handle_floating_resource("+" + str(remainder), icons[5])	
				
func remove_soldiers(amount):
	current_soldiers = clamp(current_soldiers - amount, 0, bee_cap)
	resource_ui.current_soldiers.text = str(current_soldiers)
	handle_floating_resource("-" + str(amount), icons[5])

func add_workers(amount):
	if current_workers == 0: 
		bee_tut_label.text = ("Place a worker (2)")
	if ((current_workers + amount) <= bee_cap):
		current_workers = clamp(current_workers + amount, 0, bee_cap)
		resource_ui.current_workers.text = str(current_workers)
		handle_floating_resource("+" + str(amount), icons[4])
	else:
		if ((current_workers + amount) > bee_cap):
			var remainder = bee_cap - current_workers
			if remainder == 0:
				handle_floating_resource("Max workers reached.\nUpgrade hive for more.", icons[4])
			else:
				current_workers = clamp(current_workers + remainder, 0, bee_cap)
				resource_ui.current_workers.text = str(current_workers)
				handle_floating_resource("+" + str(remainder), icons[4])

func remove_workers(amount):
	current_workers = clamp(current_workers - amount, 0, bee_cap)
	resource_ui.current_workers.text = str(current_workers)
	handle_floating_resource("-" + str(amount), icons[4])

func add_bees(amount):
	if first_bee == false && current_bees == 0:
		bee_tut_label.text = ("Add a scout")
		first_bee = true
	if ((current_bees + amount) <= bee_cap):
		current_bees = clamp(current_bees + amount, 0, bee_cap)
		resource_ui.current_bees.text = str(current_bees)
		handle_floating_resource("+" + str(amount), icons[3])
	else:
		if ((current_bees + amount) > bee_cap):
			var remainder = bee_cap - current_bees
			if remainder == 0:
				handle_floating_resource("Max bees reached.\nUpgrade hive for more.", icons[3])
			else:
				current_bees = clamp(current_bees + remainder, 0, bee_cap)
				resource_ui.current_bees.text = str(current_bees)
				handle_floating_resource("+" + str(remainder), icons[3])

func remove_bees(amount):
	current_bees = clamp(current_bees - amount, 0, bee_cap)
	resource_ui.current_bees.text = str(current_bees)
	handle_floating_resource("-" + str(amount), icons[3])

func handle_honey_production(amount):
	current_honey_producers += 1
	remove_wax(amount)

func handle_wax_production(amount):
	print("this")
	if current_wax_producers == 0:
		Globalcontrol.buildingtutlabel.text = "Build a worker production facility (6)"
	current_wax_producers +=1
	remove_wax(amount)

func handle_honey_storage(amount):
	add_honey_storage()
	remove_wax(amount)

func handle_wax_storage(amount):
	add_wax_storage()
	remove_wax(amount)

func handle_soldiers(amount):
	current_soldier_producers += 1
	remove_wax(amount)

func handle_workers(amount):
	if current_soldier_producers == 0:
		Globalcontrol.buildingtutlabel.text = "Go outside to start placing workers and scouts"
	current_worker_producers += 1
	remove_wax(amount)

func handle_nursery(amount):
	if current_nurseries == 0:
		Globalcontrol.buildingtutlabel.text = "Build a wax production facility (2)"
	current_nurseries += 1
	remove_wax(amount)

func place_scout():
	print(first_scout)
	print(current_workers)
	if first_scout == false && current_workers == 0:
		bee_tut_label.text = ("Wait for a worker to be produced.")
		first_scout = true
	if current_workers > 0 && first_scout == false:
		bee_tut_label.text = ("Place a worker (2)")
		first_scout = true
	bee_selection = scout_bee
	print("Doin it")
	place_a_bee()

func place_worker():
	print("?????")
	if work_num == 0:
		bee_tut_label.text = ("Select worker (LMouse). Set to Harvest (RMouse)")
	work_num += 1
	bee_selection = worker_bee
	place_a_bee()

func place_soldier():
	bee_selection = soldier_bee
	place_a_bee()

func handle_floating_resource(text, icon):
	ui_floater.float_text(text, icon)
	
func kill_bee(bee):
	bee.queue_free()
	match bee.bee_name:
			"Scout":
				remove_honey(3)
			"Worker":
				remove_honey(5)
			"Soldier":
				remove_honey(5)
	
func initiate_wasp_combat(bees_in_range, wasps_in_range, main_wasp):
	var bee_values = 0
	for bee in bees_in_range:
		bee_values += bee.bee_value
	var wasp_values = 0
	for wasp in wasps_in_range:
		wasp_values += wasp_value
	var bee_roll = randi_range(0, 20)
	var wasp_roll = randi_range(0, 20)
	var wasp_result = wasp_roll + wasp_values
	var bee_result = bee_roll + bee_values
	battle_screen_ui.visible = true
	battle_screen_ui.set_army_values(bee_values, wasp_values)
	var battle_timer = get_tree().create_timer(1)
	await battle_timer.timeout
	battle_screen_ui.set_roll_values(bee_roll, wasp_roll)
	var result_timer = get_tree().create_timer(1)
	await result_timer.timeout
	Globalcontrol._deselect_bee()
	Globalcontrol._deselect_bees()
	if bee_result >= wasp_result:
		battle_screen_ui.set_outcome("Bees Win!", bee_result, wasp_result)
		for wasp in wasps_in_range:
			wasp.queue_free()
		battle_screen_ui.exit_battle.visible = true
	else:
		battle_screen_ui.set_outcome("Wasps Win!", bee_result, wasp_result)
		Globalcontrol._deselect_bee()
		Globalcontrol._deselect_bees()
		for bee in bees_in_range:
			kill_bee(bee)
		battle_screen_ui.exit_battle.visible = true
		main_wasp.can_battle = true
