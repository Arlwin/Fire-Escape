extends Node2D

onready var global = get_node("/root/Global")
onready var theme = get_node("/root/GameTheme")

export var mainScene = preload("res://Prototype/Main.tscn")

var currentScene

func _ready():
	init_hud()
	currentScene = $Main
	
func init_hud():
	$HUD.setHealth(global.playerHealth if global.playerHealth != null else $Main/Player.MAX_HEALTH, $Main/Player.MAX_HEALTH)
	$HUD.setRooms(global.rooms)
	if not global.tutorial:
		$HUD/DialogBox.hide()
		$HUD.layer = 1
	if not global.gameOver:
		$HUD/GameOver.hide()
	
func _on_Main_playerHit(value, total):
	$HUD.setHealth(value, total)
	pass # Replace with function body.

func _on_Main_gameOver():
	global.gameOver = true
	theme.get_node("GameOverTheme").play()
	$HUD.showGameOver()
	pass # Replace with function body.

func _on_HUD_reset():
	theme.get_node("GameOverTheme").stop()
	theme.get_node("MainTheme").play()
	global.rooms = 0
	global.gameOver = false

	# Helpers
	global.tutorial = true
	global.slidingLevel = false

	# Player State
	global.playerHealth = null
	global.playerVelocity = null
	global.playerUp = Vector2(0, -1)
	get_tree().change_scene("res://Prototype/Prototype.tscn")
	pass # Replace with function body.

func _on_HUD_pause(state):
	get_tree().paused = state
	pass # Replace with function body.
