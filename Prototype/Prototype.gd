extends Node2D


const BARREL_SCENE = preload("res://Prototype/Barrel.tscn")
const OBS_SCENE = preload("res://Prototype/Fire.tscn")

var WINDOW_SIZE
var rng = RandomNumberGenerator.new()

var barrelReady = true
var fireReady = true

func _ready():
	WINDOW_SIZE = get_viewport_rect().size
	$BarrelTimer.start()
	$FireTimer.start()
	pass # Replace with function body.

func add_fire():
	var point1 = $Level/CollisionPolygon2D.polygon[0]
	var point2 = $Level/CollisionPolygon2D.polygon[1]
#	var angle = point2.angle_to(point1)
	
	rng.randomize()
	var x = rng.randi_range(point1.x + 100, point2.x - 50)
	var m = (point1.y - point2.y) / (point1.x - point2.x)
	var y = m * x + point1.y # y = mx + b
	var angle = atan2(point2.y - point1.y, point2.x - point1.x)
	
	var obs = OBS_SCENE.instance()
	obs.global_position = Vector2(x, y - 30)
	obs.rotation_degrees = rad2deg(angle)
	add_child(obs)
	pass

func add_barrel():
	rng.randomize()
	var barrel = BARREL_SCENE.instance()
	barrel.global_position = Vector2(generateRandomPos())
	add_child(barrel)
	
func _process(delta):
	if barrelReady:
		add_barrel()
		barrelReady = false
	if fireReady:
		add_fire()
		fireReady = false
	pass

func _on_BarrelTimer_timeout():
	barrelReady = true
	pass # Replace with function body.
	
func generateRandomPos():
	var posX = rng.randi_range(WINDOW_SIZE.x / 2, WINDOW_SIZE.x - 50)
	return Vector2(posX, 10)
	pass

func _on_FireTimer_timeout():
	fireReady = true
	pass # Replace with function body.

func _on_NextLevel_body_entered(body):
	if (body.get_name() == 'Player'):
		get_tree().change_scene("res://Prototype/Prototype.tscn")
	pass # Replace with function body.
