extends "res://entities/enemies/base_enemy.gd"

var path = []

var update_target_timer = Timer.new()

func _ready():
	
	update_target_timer.wait_time = 1
	update_target_timer.connect("timeout", self, "move_towards_player")
	
	add_child(update_target_timer)
	move_towards_player()

func move_towards_player():

	path = nav.get_simple_path(global_position, GLOBAL.player.global_position, true)
	update_target_timer.start()

func _process(delta):
	var walk_distance = MOTION_SPEED * delta
	move_along_path(walk_distance, delta)
	
	#var distance_to_player = self.get_global_position().distance_to(GLOBAL.player.get_global_position())
	#movedir = (GLOBAL.player.get_global_position() - self.get_global_position()).normalized()
	#var motion = movedir.normalized() * MOTION_SPEED
	#var collision = move_and_collide(motion * delta)

func move_along_path(distance, delta):
	var last_point = global_position

	for i in range(path.size()):
		var distance_between_points = last_point.distance_to(path[0])
		if distance <= distance_between_points and distance >= 0.0:
			global_position = last_point.linear_interpolate(path[0], distance / distance_between_points)
			break
		elif distance < 0.0:
			global_position = path[0]
			break

		distance -= distance_between_points
		last_point = path[0]
		path.remove(0)

func save_position(pos : Vector2, entity : PackedScene) -> void:

	#GLOBAL.world.add_child(self)
	self.set_global_position(GLOBAL.world.map_to_world(pos))

	GLOBAL.enemies_in_rooms.append({
		room = GLOBAL.get_object_grid_pos(self),
		instance = entity,
		map_pos = GLOBAL.world.map_to_world(pos)
	})