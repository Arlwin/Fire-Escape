extends Node2D

onready var global = get_node("/root/Global")

func _ready():
	init_hud()
	
func init_hud():
	$HUD.setHealth(global.playerHealth if global.playerHealth != null else $Main/Player.MAX_HEALTH, $Main/Player.MAX_HEALTH)
	$HUD.setRooms(global.rooms)
	if not global.tutorial:
		$HUD/DialogBox.hide()
	if not global.gameOver:
		$HUD/GameOver.hide()
	
func _on_Main_playerHit(value, total):
	$HUD.setHealth(value, total)
	pass # Replace with function body.

func _on_Main_gameOver():
	global.gameOver = true
	$HUD.showGameOver()
	pass # Replace with function body.

func _on_HUD_reset():
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
