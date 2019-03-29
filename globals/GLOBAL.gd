extends Node

var game_running : bool = true
var player : Player
var player_world_pos : Vector2
var camera : GameCamera

var room_size: Vector2 = Vector2(960, 768)

var world: TileMap
var enemies: TileMap
var minimap: TileMap 
var rooms = []

var enemies_in_rooms : Array

func _ready() -> void:
	minimap = get_tree().get_root().find_node("minimap", true, false)
	minimap.clear()

	camera = get_tree().get_nodes_in_group("camera")[0]
	world = get_tree().get_nodes_in_group("world")[0]
	enemies = get_tree().get_nodes_in_group("enemy_tiles")[0]

	load_enemies()
	get_rooms()
	
	for cell in rooms:
		minimap.set_cellv(cell, 0)

func load_enemies() -> void:
	for cell in enemies.get_used_cells():
		var name = enemies.tile_set.tile_get_name(enemies.get_cellv(cell))
		if name == "enemy":
			enemies.set_cellv(cell, -1)
			var e = load("res://entities/enemies/enemy.tscn")
			e.instance().save_position(cell, e)

func get_rooms() -> void:
	var cells_in_world = world.get_used_cells()
	
	
	var room_width = room_size.x / 32
	var room_height = room_size.y / 32

	var look_at = world.world_to_map(get_lowest_cell(world))
	var minimap_position = Vector2(0, 0)

	var tilemap_size = calculate_tilemap_size(world)

	for c in cells_in_world:
		if c.x >= look_at.x and c.x <= look_at.x + room_width \
		and c.y >= look_at.y and c.y <= look_at.y + room_height:
			look_at.x += room_width + 1
			rooms.append(minimap_position)
			minimap_position.x += 1

			if look_at.x > tilemap_size.width:
				look_at.x = 0
				look_at.y += room_height + 1
				minimap_position.x = 0
				minimap_position.y += 1

	print("There are %s rooms" % rooms.size())

func get_lowest_cell(tilemap : TileMap) -> Vector2:

	var lowest_cell = tilemap.get_used_cells()[0]

	for cell in tilemap.get_used_cells():
		if cell.x <= lowest_cell.x and cell.y <= lowest_cell.y:
			lowest_cell = cell

	return lowest_cell

func calculate_tilemap_size(tilemap : TileMap) -> Dictionary:
	var used_cells = tilemap.get_used_cells()

	if used_cells.size() == 0: return {x=0, y=0, width=0, height=0}

	var min_x = used_cells[0].x
	var min_y = used_cells[0].y
	var max_x = min_x
	var max_y = min_y

	for i in range(1, used_cells.size()):
		var pos = used_cells[i]

		if pos.x < min_x: min_x = pos.x
		elif pos.x > max_x: max_x = pos.x

		if pos.y < min_y: min_y = pos.y
		elif pos.y > max_y: max_y = pos.y

	return {
		width = max_x - min_x + 1,
		height = max_y - min_y + 1
	}

func pause_game() -> void:
	game_running = false
	
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if get_object_grid_pos(enemy) != player_world_pos:
			enemy.queue_free()
			print("enemy killed")

func unpause_game() -> void:
	spawn_room()
	update_map()
	game_running = true

func get_object_grid_pos(object) -> Vector2:
	var pos = object.get_global_position()
	return Vector2(floor(pos.x / room_size.x), floor(pos.y / room_size.y))

func update_map() -> void:
	minimap.set_cellv(player_world_pos, 0)
	minimap.get_node("player_pos").set_position(minimap.map_to_world(player_world_pos))

func toggle_map() -> void:
	var view = get_tree().get_root().find_node("map_view", true, false)
	
func spawn_room() -> void:
	for enemy in enemies_in_rooms:
		if enemy.room == player_world_pos:
			var e = enemy.instance.instance()
			e.get_node("sprite").centered = false
			e.set_global_position(enemy.map_pos)
			world.add_child(e)