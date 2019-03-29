extends KinematicBody2D

onready var map : TileMap
onready var nav : Navigation2D

# Called when the node enters the scene tree for the first time.
func _ready():
	map = get_tree().get_nodes_in_group("world")[0]
	nav = get_tree().get_nodes_in_group("nav")[0]