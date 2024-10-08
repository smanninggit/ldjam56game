extends Node3D

const TILE_SIZE := 0.5
const HEXAGON_TILE = preload("res://models/pieces/hexagon_tile.tscn")

signal queen_ready

@export var grid_size: int

func _ready() -> void:
	_generate_grid()
	
func _generate_grid():
	for q in range(-grid_size, grid_size + 1):
		for r in range(-grid_size, grid_size + 1):
			if abs(q + r) <= grid_size:  # Ensure it's within the hexagonal shape
				var tile = HEXAGON_TILE.instantiate()
				add_child(tile)
				var tile_position = axial_to_world(q, r)
				tile.translate(Vector3(tile_position.x, 0, tile_position.y))
				if q == 0 && r == 0:
					Globalcontrol.first_tile = tile
					print("emitting signal")
					queen_ready.emit()
					emit_signal("queen_ready")

func axial_to_world(q: int, r: int) -> Vector2:
	var x = TILE_SIZE * 3/2 * q
	var y = TILE_SIZE * sqrt(3) * (r + q / 2.0)
	return Vector2(x, y)
