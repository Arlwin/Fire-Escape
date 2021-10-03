extends Node2D

const BARREL_SCENE = preload("res://Prototype/Barrel.tscn")
const OBS_SCENE = preload("res://Prototype/Fire.tscn")
const FIRE_INDENT = 400

export var Barrels = true
export var Fire = true

export var Ground_Offset = 568

var barrelReady = false
var fireReady = false

onready var WINDOW_SIZE = get_viewport_rect().size

onready var point1 = $FloorPlane/Floor/CollisionPolygon2D.polygon[0]
onready var point2 = $FloorPlane/Floor/CollisionPolygon2D.polygon[1]

var initialVector
onready var global = get_node("/root/Global")

var randAngle

func _ready():
	randomize()
	randAngle = rand_range(-30, 40)
	$FloorPlane/Floor.rotation_degrees = randAngle
	
	global.playerUp = Vector2(sin(deg2rad(randAngle)),  -cos(deg2rad(randAngle)))
	
	initialVector = Vector2(10, 20)
	
	if Barrels:
		$BarrelTimer.start()
	else:
		$BarrelTimer.stop()
		
	if Fire:
		randomize()
		for i in (randi() % (5 - 1) + 1):
			add_fire()
		$FireTimer.start()
	else:
		$FireTimer.stop()
	pass # Replace with function body.

func _process(delta):
	if barrelReady:
		add_barrel()
		barrelReady = false
	if fireReady:
		add_fire()
		fireReady = false
	pass
	
func add_fire():
	randomize()

	var x = rand_range(0 - FIRE_INDENT, WINDOW_SIZE.x / 2)
	var y = tan($FloorPlane/Floor.rotation) * x # y = mx + b

	var obs = OBS_SCENE.instance()
	obs.position = Vector2(x, y - 30)
	obs.global_rotation_degrees = randAngle
	
	global.slidingLevel = randAngle > 0
	
	$FloorPlane.add_child(obs, true)
	pass

func add_barrel():
	randomize()
	var barrel = BARREL_SCENE.instance()
	barrel.global_position = Vector2(generateRandomPos())
	add_child(barrel, true)
	
func generateRandomPos():
	var posX = rand_range(100, WINDOW_SIZE.x - 100)
	return Vector2(posX, 10)
	pass

func _on_BarrelTimer_timeout():
	barrelReady = true
	pass # Replace with function body.

func _on_FireTimer_timeout():
	fireReady = true
	pass # Replace with function body.
