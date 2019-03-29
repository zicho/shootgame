extends Camera2D
class_name GameCamera

onready var player = get_parent().find_node("player")

func _ready():
	GLOBAL.camera = self
	GLOBAL.player_world_pos = GLOBAL.get_object_grid_pos(player)
	set_camera()

func set_camera():
	
	var new_transform = get_canvas_transform()
	new_transform[2] = -GLOBAL.player_world_pos * GLOBAL.room_size

	# THE TWEEN IS CONNECTED TO A SINGLETON (GLOBAL) SETTER METHOD IN THE EDITOR
	# DID NOT WORK IN CODE FOR SOME REASON?

	get_viewport().canvas_transform = new_transform
	GLOBAL.update_map()
	
func update_camera():

	var new_player_grid_pos = GLOBAL.get_object_grid_pos(player)
	var new_transform = get_canvas_transform()

	if new_player_grid_pos != GLOBAL.player_world_pos:
		GLOBAL.player_world_pos = new_player_grid_pos
		new_transform[2] = -GLOBAL.player_world_pos * GLOBAL.room_size

		# THE TWEEN IS CONNECTED TO A SINGLETON (GLOBAL) SETTER METHOD IN THE EDITOR
		# DID NOT WORK IN CODE FOR SOME REASON?

		$tween.interpolate_property(
			get_viewport(),
			"canvas_transform",
			get_viewport().canvas_transform,
			new_transform,
			0.6,
			Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)

		$tween.start()

func _on_tween_tween_started(object, key):
	GLOBAL.pause_game()

func _on_tween_tween_completed(object, key):
	GLOBAL.unpause_game()
	GLOBAL.update_map()
