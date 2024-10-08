class_name GlobalControl
extends Node3D


var currentlySelectedCell: Node3D
var previouslySelectedCell: Node3D
var newCell: Node3D

var currentBuildUI

var currentlySelectedTree: Node3D
var previouslySelectedTree: Node3D

var currentlySelectedHive: Node3D
var previouslySelectedHive: Node3D

var currentlySelectedBee: Node3D
var previouslySelectedBee: Node3D
var currentlySelectedBees = []

@onready var camera: Node3D = get_tree().root.get_node("Node3D/Camera3D")
var selectedCellName: String
var selectedCellDescription: String

var selectedBeeName: String
var selectedBeeSpeed: int
var selectedBeeDescription: String

var treeRemainingResources: int

var hiveName : String
var hiveDescription : String
var hiveStatus : bool

var raycast = RayCast3D.new()

var first_out = false

var OutsideScene: PackedScene = preload("res://outside.tscn")
var MediumHiveScene: PackedScene = preload("res://medium_hive.tscn")
var LargeHiveScene: PackedScene = preload("res://large_hive.tscn")
var SmallHiveScene: PackedScene
var loaded_scenes: Array = []
var current_scene: Node3D = null

var is_outside: bool = false

var buildingtutlabel
var first_wax = false
var first_nursery = false
var first_worker = false

var settings_menu_ui

var one_added = false

@export var buildings = [
	preload("res://models/insidehive/buildingtiles/honey_production_building.tscn"),
	preload("res://models/insidehive/buildingtiles/wax_production_building.tscn"),
	preload("res://models/insidehive/buildingtiles/honey_storage_building.tscn"),
	preload("res://models/insidehive/buildingtiles/wax_storage_building.tscn"),
	preload("res://models/insidehive/buildingtiles/soldier_training_building.tscn"),
	preload("res://models/insidehive/buildingtiles/worker_training_building.tscn"),
	preload("res://models/insidehive/buildingtiles/nursery_building.tscn"),
]

var first_tile: Node3D
var first_select = false

@export var queen_building = preload("res://models/insidehive/buildingtiles/queen_building.tscn")
@onready var hexagon_grid: Node3D = get_tree().root.get_node("Node3D/HexagonGrid")
@onready var cell_info_ui: Control = get_tree().root.get_node("Node3D/UI/SelectedCellInfo")
@onready var bee_info_ui: Control = get_tree().root.get_node("Node3D/UI/SelectedBeeInfo")
@onready var tree_info_ui: Control = get_tree().root.get_node("Node3D/UI/SelectedResourceInfo")
@onready var building_selection_ui: Control = get_tree().root.get_node("Node3D/UI/BuildingSelection")
@onready var go_outside_button: Control = get_tree().root.get_node("Node3D/UI/GoOutside")
@onready var go_inside_button: Control = get_tree().root.get_node("Node3D/UI/GoInside")
@onready var small_hive_camera: Camera3D = get_tree().root.get_node("Node3D/Camera3D")
var medium_hive_camera: Camera3D
var large_hive_camera: Camera3D
@onready var bee_selection_ui: Control = get_tree().root.get_node("Node3D/UI/BeeSelection")
@onready var multi_bee_ui: Control = get_tree().root.get_node("Node3D/UI/MultiBees")
@onready var battle_screen_ui: Control = get_tree().root.get_node("Node3D/UI/BattleScreen")
@onready var hive_info_ui: Control = get_tree().root.get_node("Node3D/UI/SelectedHiveInfo")

func _ready() -> void:
	currentlySelectedBee = null
	previouslySelectedBee = null
	currentlySelectedBees.clear()
	currentlySelectedTree = null
	previouslySelectedTree = null
	currentlySelectedCell = null
	previouslySelectedCell = null
	is_outside = false
	first_tile = null
	loaded_scenes.clear()
	loaded_scenes.append(get_tree().current_scene)
	current_scene = get_tree().current_scene
	var nodes_in_buildingtut = get_tree().get_nodes_in_group("buildingtut")
	buildingtutlabel = nodes_in_buildingtut[0]
	print("got here")
	if get_tree().current_scene.name == "Node3D":
		print("not passing")
		hexagon_grid.queen_ready.connect(initialize_queen)
	else:
		print("passing :(")
		pass

func get_medium_camera():
	var nodes_in_med_cam = get_tree().get_nodes_in_group("medcam")
	medium_hive_camera = nodes_in_med_cam[0]
	
func get_large_camera():
	var nodes_in_large_cam = get_tree().get_nodes_in_group("largecam")
	large_hive_camera = nodes_in_large_cam[0]

func reset_me():
	currentlySelectedBee = null
	previouslySelectedBee = null
	currentlySelectedBees.clear()
	currentlySelectedTree = null
	previouslySelectedTree = null
	currentlySelectedCell = null
	previouslySelectedCell = null
	is_outside = false
	first_tile = null
	loaded_scenes.clear()
	loaded_scenes.append(get_tree().current_scene)
	current_scene = get_tree().current_scene
	hexagon_grid.queen_ready.connect(initialize_queen)

func initialize_queen():
	print("queen time")
	if first_tile != null:
		var queen_cell = queen_building.instantiate()
		hexagon_grid.add_child(queen_cell)
		queen_cell.position = first_tile.position
		first_tile.queue_free()
		hexagon_grid.queen_ready.disconnect(initialize_queen)
		
func _handle_selected_cell():
	var selector_indicator = currentlySelectedCell.get_child(1)
	if (selector_indicator != null):
		selector_indicator.visible = true
		get_cell_info()
	if (previouslySelectedCell != null):
		var previous_selector_indicator = previouslySelectedCell.get_child(1)
		if (previous_selector_indicator != null):
			previous_selector_indicator.visible = false
			
func _handle_selected_bee():
	var selector_indicator = currentlySelectedBee.get_child(0)
	if (selector_indicator != null):
		selector_indicator.visible = true
		get_bee_info()
	if (previouslySelectedBee != null):
		var previous_selector_indicator = previouslySelectedBee.get_child(0)
		if (previous_selector_indicator != null):
			previous_selector_indicator.visible = false

func _handle_multi_select_bees():
	multi_bee_ui.clear_bees()
	for bee in currentlySelectedBees:
		multi_bee_ui.visible = true
		multi_bee_ui.add_a_bee(bee.bee_name)
		var selector_indicator = bee.get_child(0)
		if (selector_indicator != null):
			selector_indicator.visible = true
			
func _handle_selected_tree():
	var selector_indicator = currentlySelectedTree.get_child(0)
	if (selector_indicator != null):
		selector_indicator.visible = true
		get_tree_info()
	if (previouslySelectedTree != null):
		var previous_selector_indicator = previouslySelectedTree.get_child(0)
		if (previous_selector_indicator != null):
			previous_selector_indicator.visible = false

func _handle_selected_hive():
	var selector_indicator = currentlySelectedHive.get_child(0)
	if (selector_indicator != null):
		selector_indicator.visible = true
		get_hive_info()
	if (previouslySelectedHive != null):
		var previous_selector_indicator = previouslySelectedHive.get_child(0)
		if (previous_selector_indicator != null):
			previous_selector_indicator.visible = false
	
func select_cell(selected_cell):
	if first_select == false:
		buildingtutlabel.text = "Build a nursery (7)"
		first_select = true
	if (currentlySelectedCell != null && currentlySelectedCell != selected_cell):
		previouslySelectedCell = currentlySelectedCell
		cell_info_ui.visible = true
	currentlySelectedCell = selected_cell
	_handle_selected_cell()
	
func select_bee(selected_bee):
	_deselect_bees()
	_deselect_tree()
	_deselect_hive()
	if (currentlySelectedBee != null && currentlySelectedBee != selected_bee):
		previouslySelectedBee = currentlySelectedBee
		bee_info_ui.visible = true
	currentlySelectedBee = selected_bee
	_handle_selected_bee()
	
func select_another_bee(selected_bee):
	if one_added == false && currentlySelectedBee != null:
		currentlySelectedBees.append(currentlySelectedBee)
		one_added = true
		currentlySelectedBees.append(selected_bee)
		_handle_multi_select_bees()
	else:
		currentlySelectedBees.append(selected_bee)
		_handle_multi_select_bees()
	
func select_resource(selected_tree):
	_deselect_bee()
	_deselect_bees()
	_deselect_hive()
	if (currentlySelectedTree != null && currentlySelectedTree != selected_tree):
		previouslySelectedTree = currentlySelectedTree
		tree_info_ui.visible = true
	currentlySelectedTree = selected_tree
	_handle_selected_tree()

func select_hive(selected_hive):
	_deselect_bee()
	_deselect_bees()
	_deselect_tree()
	if (currentlySelectedHive != null && currentlySelectedHive != selected_hive):
		previouslySelectedHive = currentlySelectedHive
		hive_info_ui.visible = true
	currentlySelectedHive = selected_hive
	_handle_selected_hive()

func _deselect_cell():
	if currentlySelectedCell != null:
		var selector_indicator = currentlySelectedCell.get_child(1)
		if (selector_indicator != null):
			currentlySelectedCell = null
			selector_indicator.visible = false
			cell_info_ui.visible = false

func _deselect_bee():
	if currentlySelectedBee != null:
		var selector_indicator = currentlySelectedBee.get_child(0)
		if (selector_indicator != null):
			currentlySelectedBee = null
			selector_indicator.visible = false
			bee_info_ui.visible = false
			
func _deselect_bees():
	one_added = false
	multi_bee_ui.clear_bees()
	multi_bee_ui.visible = false
	if currentlySelectedBees.is_empty() == false:
		for bee in currentlySelectedBees:
			var selector_indicator = bee.get_child(0)
			if (selector_indicator != null):
				selector_indicator.visible = false
				bee_info_ui.visible = false
		currentlySelectedBees.clear()

func _deselect_tree():
	if currentlySelectedTree != null:
		var selector_indicator = currentlySelectedTree.get_child(0)
		if (selector_indicator != null):
			currentlySelectedTree = null
			selector_indicator.visible = false
			tree_info_ui.visible = false
			
func _deselect_hive():
	if currentlySelectedHive != null:
		var selector_indicator = currentlySelectedHive.get_child(0)
		if (selector_indicator != null):
			currentlySelectedHive = null
			selector_indicator.visible = false
			hive_info_ui.visible = false

func replace_cell(index):
	if currentlySelectedCell != null && currentlySelectedCell.cell_name == "Empty Cell":
		newCell = buildings[index].instantiate()
		if Globalresources.current_hive == 0:
			hexagon_grid.add_child(newCell)
		if Globalresources.current_hive == 1:
			var nodes_in_med_hex= get_tree().get_nodes_in_group("medhex")
			var med_hexagon_grid = nodes_in_med_hex[0]
			med_hexagon_grid.add_child(newCell)
		if Globalresources.current_hive == 2:
			var nodes_in_large_hex= get_tree().get_nodes_in_group("largehex")
			var large_hexagon_grid = nodes_in_large_hex[0]
			print(large_hexagon_grid.name)
			large_hexagon_grid.add_child(newCell)
		newCell.visible = false
		check_can_build()
		
	
func check_can_build():
	if Globalresources.current_wax >= newCell.wax_cost:
		currentlySelectedCell.queue_free()
		newCell.visible = true
		newCell.position = currentlySelectedCell.position
		_handle_cell_functions(newCell.wax_cost)
		_deselect_cell()
	else:
		Globalresources.handle_floating_resource("Not enough wax", Globalresources.icons[1])
			
func get_cell_info():
	cell_info_ui.visible = true
	var cellInfo = currentlySelectedCell
	selectedCellName = cellInfo.cell_name
	selectedCellDescription = cellInfo.description
	cell_info_ui.on_selected_changed()

func get_bee_info():
	bee_info_ui.visible = true
	var beeInfo = currentlySelectedBee
	selectedBeeName = beeInfo.bee_name
	selectedBeeSpeed = beeInfo.bee_speed
	selectedBeeDescription = beeInfo.description
	bee_info_ui.on_selected_changed()
	
func get_tree_info():
	tree_info_ui.visible = true
	var treeInfo = currentlySelectedTree
	treeRemainingResources = treeInfo.remaining_resources
	tree_info_ui.on_selected_changed()

func get_hive_info():
	hive_info_ui.visible = true
	var hiveInfo = currentlySelectedHive
	hiveName = hiveInfo.hive_name
	hiveDescription = hiveInfo.hive_description
	hiveStatus  = hiveInfo.hive_status
	hive_info_ui.on_selected_changed()
	
func _handle_cell_functions(amount):
	match newCell.cell_name:
		"Honey Production":
			Globalresources.handle_honey_production(amount)
		"Wax Production":
			Globalresources.handle_wax_production(amount)
		"Honey Storage":
			Globalresources.handle_honey_storage(amount)
		"Wax Storage":
			Globalresources.handle_wax_storage(amount)
		"Soldier Training":
			Globalresources.handle_soldiers(amount)
		"Worker Training":
			Globalresources.handle_workers(amount)
		"Nursery":
			Globalresources.handle_nursery(amount)

func switch_to_outside():
	if first_out == false:
		var nodes_in_settings = get_tree().get_nodes_in_group("settingsmenu")
		settings_menu_ui = nodes_in_settings[0]
		buildingtutlabel.visible = false
		first_out = true
	_deselect_cell()
	settings_menu_ui.check_box.disabled = false
	current_scene.visible = false
	if self.get_child_count() < 1:
		current_scene = OutsideScene.instantiate()
		add_child(current_scene)
		loaded_scenes.append(current_scene)
	else:
		current_scene = self.get_child(0)
	if Globalresources.current_hive == 0:
		building_selection_ui.visible = false
	else:
		currentBuildUI.visible = false
	bee_selection_ui.visible = true
	go_outside_button.visible = false
	go_inside_button.visible = true
	current_scene.get_child(0).get_child(0).make_current()
	if Globalresources.current_hive == 0:
		current_scene.get_child(0).position = Vector3(-16, 11, 54)
	if Globalresources.current_hive == 1:
		current_scene.get_child(0).position = Vector3(30, 11, 26)
	if Globalresources.current_hive == 2:
		current_scene.get_child(0).position = Vector3(125, 11, -13)
	is_outside = true
	if Globalresources.current_hive == 0:
		Globalresources.hive_1_target = get_tree().root.get_node("Globalcontrol/Node3D/Hive1Target")
	if Globalresources.current_hive == 1:
		Globalresources.hive_1_target = get_tree().root.get_node("Globalcontrol/Node3D/Hive2Target")
	if Globalresources.current_hive == 2:
		Globalresources.hive_1_target = get_tree().root.get_node("Globalcontrol/Node3D/Hive3Target")
	Globalresources.battle_screen_ui = battle_screen_ui
	current_scene.visible = true
	
func attain_medium_hive():
	settings_menu_ui.check_box.disabled = false
	var nodes_in_small = get_tree().get_nodes_in_group("smallhive")
	var small_hive = nodes_in_small[0]
	var nodes_in_medium = get_tree().get_nodes_in_group("mediumhive")
	var medium_hive = nodes_in_medium[0]
	medium_hive.get_child(0).hive_status = true
	small_hive.get_child(0).hive_status = false
	var add_medium
	Globalresources.current_hive = 1
	Globalresources.update_max_bees()
	Globalresources.egg_amount = 2
	Globalresources.reset_producers
	add_medium = MediumHiveScene.instantiate()
	add_medium.visible = false
	add_child(add_medium)
	var nodes_in_med_build = get_tree().get_nodes_in_group("medbuild")
	nodes_in_med_build[0].visible = false
	get_medium_camera()
	medium_hive_camera.current = false
	loaded_scenes.append(add_medium)

func attain_large_hive():
	var nodes_in_small = get_tree().get_nodes_in_group("smallhive")
	var small_hive = nodes_in_small[0]
	var nodes_in_large = get_tree().get_nodes_in_group("largehive")
	var large_hive = nodes_in_large[0]
	var nodes_in_medium = get_tree().get_nodes_in_group("mediumhive")
	var medium_hive = nodes_in_medium[0]
	medium_hive.get_child(0).hive_status = false
	large_hive.get_child(0).hive_status = true
	small_hive.get_child(0).hive_status = false
	var add_large
	Globalresources.current_hive = 2
	Globalresources.update_max_bees()
	Globalresources.egg_amount = 3
	Globalresources.reset_producers
	add_large = LargeHiveScene.instantiate()
	add_large.visible = false
	add_child(add_large)
	var nodes_in_large_build = get_tree().get_nodes_in_group("largebuild")
	nodes_in_large_build[0].visible = false
	get_large_camera()
	large_hive_camera.current = false
	loaded_scenes.append(add_large)

func switch_to_hive():
	_deselect_bee()
	_deselect_bees()
	_deselect_tree()
	_deselect_hive()
	settings_menu_ui.check_box.disabled = true
	current_scene.visible = false
	if Globalresources.current_hive == 0:
		building_selection_ui.visible = true
		current_scene = loaded_scenes[0]
	if Globalresources.current_hive == 1:
		if building_selection_ui != null:
			building_selection_ui.queue_free()
		if currentBuildUI == null:
			var nodes_in_med_build = get_tree().get_nodes_in_group("medbuild")
			currentBuildUI = nodes_in_med_build[0]
		currentBuildUI.visible = true
		current_scene = loaded_scenes[2]
	if Globalresources.current_hive == 2:
		var nodes_in_large_build2 = get_tree().get_nodes_in_group("largebuild")
		if currentBuildUI == null:
			var nodes_in_large_build = get_tree().get_nodes_in_group("largebuild")
			currentBuildUI = nodes_in_large_build[0]
		if currentBuildUI != nodes_in_large_build2[0]:
			var nodes_in_large_build = get_tree().get_nodes_in_group("largebuild")
			currentBuildUI = nodes_in_large_build[0]
		currentBuildUI.visible = true
		current_scene = loaded_scenes[3]
	bee_selection_ui.visible = false
	go_outside_button.visible = true
	go_inside_button.visible = false
	if Globalresources.current_hive == 0:
		small_hive_camera.make_current()
	if Globalresources.current_hive == 1:
		medium_hive_camera.make_current()
	if Globalresources.current_hive == 2:
		large_hive_camera.make_current()
	is_outside = false
	current_scene.visible = true
