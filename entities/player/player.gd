extends "res://entities/entity.gd"
class_name Player

signal player_moves

func _ready() -> void:
	
	GLOBAL.player = self
	connect("player_moves", GLOBAL.camera, "update_camera")
	scale = Vector2(2, 2)

func _process(delta : float) -> void:

	var RS_direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_RX), Input.get_joy_axis(0, JOY_ANALOG_RY))
	var LS_direction = Vector2(Input.get_joy_axis(0, JOY_ANALOG_LX), Input.get_joy_axis(0, JOY_ANALOG_LY))

	if GLOBAL.game_running:
		weapon_loop(RS_direction)
		movement_loop(LS_direction)

func movement_loop(LS_direction : Vector2):

	var motion = Vector2()
	if Input.is_action_just_pressed("ui_accept"):
		GLOBAL.toggle_map()
	if Input.is_action_pressed("ui_up"):
		motion += LS_direction
		$anim.play("move")
	elif Input.is_action_pressed("ui_down"):
		motion += LS_direction
		$anim.play("move")
	elif Input.is_action_pressed("ui_left"):
		motion += LS_direction
		$anim.play("move")
	elif Input.is_action_pressed("ui_right"):
		motion += LS_direction
		$anim.play("move")
	else: $anim.play("idle")

	motion = motion.normalized() * 320
	move_and_slide(motion)
	emit_signal("player_moves")

func weapon_loop(RS_direction : Vector2):
	
	if RS_direction.x > 0.1:
		$sprite.scale.x = 1
		$weapon.get_node("sprite").scale.y = 1
	elif RS_direction.x < -0.1:
		$sprite.scale.x = -1
		$weapon.get_node("sprite").scale.y = -1
	
	$weapon.global_position = $hand.global_position
	if Input.is_action_pressed("shoot"):
		if $weapon.can_shoot:
			$weapon.shoot(RS_direction.normalized())

	var joy_x = Input.get_joy_axis(0, 2)
	var joy_y = Input.get_joy_axis(0, 2)
	
	var sense = 0.09
	
	if (
	joy_x != 0 and 
	joy_x > sense or joy_x < -sense and
	joy_y != 0 and 
	joy_y > sense or joy_y < -sense
	):
		$crosshair.global_position = global_position + Vector2(Input.get_joy_axis(0, 2), Input.get_joy_axis(0, 3)).normalized() * 200
		
	$weapon.look_at($crosshair.global_position)

