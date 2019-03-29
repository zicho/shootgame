extends "res://entities/entity.gd"

var movedir = Vector2(0, 0)
const MOTION_SPEED = 100 # Pixels/second
const CHASE_SPEED = 50 # GETS ADDED TO MOVE SPEED ON CHASING
var active = false

func _ready()  -> void:
	add_to_group("enemies")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta)  -> void:
	
	if GLOBAL.get_object_grid_pos(self) == GLOBAL.player_world_pos: active = true

	if active and GLOBAL.game_running:
		movement_loop(delta)

func movement_loop(delta) -> void:
	pass
