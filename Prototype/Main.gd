extends Node2D

signal nextLevel()
signal playerHit(value, total)
signal hideTutDialog()
signal gameOver()

onready var global = get_node("/root/Global")

const BARREL_SCENE = preload("res://Prototype/Barrel.tscn")
const OBS_SCENE = preload("res://Prototype/Fire.tscn")

export(Array, PackedScene) var LEVELS = [
	preload("res://Prototype/Level_1.tscn")
]

export (PackedScene) var TUTORIAL_LEVEL = preload("res://Prototype/Level_0.tscn")

onready var WINDOW_SIZE = get_viewport_rect().size
var rng = RandomNumberGenerator.new()
var level

var tutorialLevel = true

func _ready():
	add_level()
	init_pos()
	pass # Replace with function body.
	
func add_level():
	if global.tutorial:
		level = TUTORIAL_LEVEL.instance()
	else:
		rng.randomize()
		var levelIndex = rng.randi_range(0, LEVELS.size() - 1)
		level = LEVELS[levelIndex].instance()
	add_child(level, true)
	move_child(level, 0)
	pass
	
func init_pos():
	$Player.position.y = $Level.initialVector.y - 10
	print($Player.position)

func generateRandomPos():
	var posX = rng.randi_range(WINDOW_SIZE.x / 2, WINDOW_SIZE.x - 50)
	return Vector2(posX, 10)
	pass

func _on_Player_playerHit(value, total):
	emit_signal("playerHit", value, total)
	pass # Replace with function body.
	
func _on_NextLevel_body_entered(body):
	if (body.get_name() == 'Player'):
		if global.tutorial:
			global.tutorial = false
		global.rooms += 1
		get_tree().change_scene("res://Prototype/Prototype.tscn")
	pass # Replace with function body.

func _on_Player_gameOver(done):
	print(done)
	if not done:
		$Player/Camera2D.current = true
	else:
		remove_child($Player)
		remove_child(level)
		emit_signal("gameOver")
	pass # Replace with function body.
