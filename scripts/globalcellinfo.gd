class_name GlobalCellInfo
extends Node

var cell_info = {
	"honey_production":{
		"name": "Honey Production",
		"description": "This cell produces honey.\n\nCost to build: 15 wax\nProduction: 5 honey per minute\nProduction Cost: 2 pollen.",
		"wax_cost": 15,
		"honey_production": 5,
		"wax_production": 0,
		"unit_producation": 0,
		"production_cost": 2,
		"production_rate": 5,
	},
	"wax_production":{
		"name": "Wax Production",
		"description": "This cell produces wax.\n\nCost to build: 15 wax\nProduction: 2 wax per 5 seconds\nProduction Cost: 2 pollen.",
		"wax_cost": 15,
		"honey_production": 0,
		"wax_production": 2,
		"unit_producation": 0,
		"production_cost": 2,
		"production_rate": 5,
	},
	"honey_storage":{
		"name": "Honey Storage",
		"description": "This cell increases honey storage capacity by 20.",
		"wax_cost": 15,
		"honey_production": 0,
		"wax_production": 0,
		"unit_producation": 0,
		"production_cost": 2,
		"production_rate": 0,
	},
	"wax_storage":{
		"name": "Wax Storage",
		"description": "This cell increases wax storage capacity by 20.",
		"wax_cost": 15,
		"honey_production": 0,
		"wax_production": 0,
		"unit_producation": 0,
		"production_cost": 0,
		"production_rate": 0,
	},
	"soldier_training":{
		"name": "Soldier Training",
		"description": "This cell trains soldiers. One soldier is produced per bee added.",
		"wax_cost": 20,
		"honey_production": 0,
		"wax_production": 0,
		"unit_producation": 1,
		"production_cost": 1,
		"production_rate": 20,
	},
	"worker_training":{
		"name": "Worker Training",
		"description": "This cell trains workers. One soldier is produced per bee added.",
		"wax_cost": 20,
		"honey_production": 0,
		"wax_production": 0,
		"unit_producation": 1,
		"production_cost": 1,
		"production_rate": 20,
	},
	"nursery":{
		"name": "Nursery",
		"description": "This cell hatches eggs. One bee is produced per egg added.",
		"wax_cost": 10,
		"honey_production": 0,
		"wax_production": 0,
		"unit_producation": 1,
		"production_cost": 1,
		"production_rate": 5,
	},
	"queen":{
		"name": "Queen",
		"description": "This is the queen cell. She lays eggs.",
		"wax_cost": 0,
		"honey_production": 0,
		"wax_production": 0,
		"unit_producation": 0,
		"production_cost": 0,
		"production_rate": 0,
	},
}

var bee_info = {
	"scout_bee":{
		"name": "Scout",
		"speed": 10,
		"ability": "Speed",
		"description": "A very fast bee, good for exploration"
	},
	"worker_bee":{
		"name": "Worker",
		"speed": 4,
		"ability": "Gathering",
		"description": "Specialized in gathering resources."
	},
	"solder_bee":{
		"name": "Soldier",
		"speed": 6,
		"ability": "Combat",
		"description": "A bee primed for fighting. Use to defend the hive"
	},
}
