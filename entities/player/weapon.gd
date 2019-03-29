extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (float) var shot_delay : float
export (PackedScene) var projectile : PackedScene

export (float) var spread : float
export (int) var projectile_speed : int

onready var shot_timer : Timer = Timer.new()
onready var can_shoot : bool = true

onready var player : KinematicBody2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(shot_timer)
	shot_timer.wait_time = shot_delay
	shot_timer.connect("timeout", self, "can_shoot")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func calculate_angle(dir : Vector2) -> Vector2:
	
	dir = (get_parent().get_node("crosshair").get_global_position() - self.get_global_position()).normalized()
	
	return Vector2(dir.x + rand_range(-spread, spread), (dir.y + rand_range(-spread, spread)))

func can_shoot() -> void:
	can_shoot = true

func shoot(dir : Vector2) -> void:
	if projectile:
		var p = projectile.instance()
		
		p.rotation = rotation
		p.speed = projectile_speed
		
		p.spawn($barrel.get_global_position(), calculate_angle(dir))
		
		can_shoot = false
		shot_timer.start()
		player.map.add_child(p)