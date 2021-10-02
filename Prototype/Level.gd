extends StaticBody2D

const BARREL_SCENE = preload("res://Prototype/Barrel.tscn")
const OBS_SCENE = preload("res://Prototype/Fire.tscn")

export var Barrels = true
export var Fire = true

var barrelReady = false
var fireReady = false

onready var WINDOW_SIZE = get_viewport_rect().size
onready var point1 = $CollisionPolygon2D.polygon[0]
onready var point2 = $CollisionPolygon2D.polygon[1]

onready var initialVector = point1
onready var global = get_node("/root/Global")

func _ready():
	if Barrels:
		add_barrel()
		$BarrelTimer.start()
	else:
		$BarrelTimer.stop()
		
	if Fire:
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
	var x = rand_range(point1.x + 100, point2.x - 50)
	var m = (point1.y - point2.y) / (point1.x - point2.x)
	var y = m * x + point1.y # y = mx + b
	var angle = atan2(point2.y - point1.y, point2.x - point1.x)
	
	var obs = OBS_SCENE.instance()
	obs.global_position = Vector2(x, y - 30)
	obs.rotation_degrees = rad2deg(angle)
	
	global.slidingLevel = angle > 0
	
	add_child(obs, true)
	pass

func add_barrel():
	randomize()
	var barrel = BARREL_SCENE.instance()
	barrel.global_position = Vector2(generateRandomPos())
	add_child(barrel, true)
	
func generateRandomPos():
	var posX = rand_range(WINDOW_SIZE.x / 2, WINDOW_SIZE.x - 50)
	return Vector2(posX, 10)
	pass

func _on_BarrelTimer_timeout():
	barrelReady = true
	pass # Replace with function body.

func _on_FireTimer_timeout():
	fireReady = true
	pass # Replace with function body.
