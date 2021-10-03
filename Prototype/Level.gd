extends Node2D

onready var WINDOW_SIZE = get_viewport_rect().size
onready var point1 = $Ground/CollisionPolygon2D.polygon[0]
onready var point2 = $Ground/CollisionPolygon2D.polygon[1]

onready var initialVector = point1
onready var global = get_node("/root/Global")

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
