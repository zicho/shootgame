extends KinematicBody2D

var motion = Vector2()
var speed : int = 0

func _physics_process(delta):
	
	var collision = move_and_collide(motion * delta)
	
	if collision:
		
		var c = collision.get_collider()
		
		if c.is_in_group("enemies"): c.queue_free()
		
		queue_free()
	
	if GLOBAL.get_object_grid_pos(self) != GLOBAL.player_world_pos:
		queue_free()
		

func spawn(pos : Vector2, dir : Vector2) -> void:
	global_position = pos
	motion = dir.normalized() * speed