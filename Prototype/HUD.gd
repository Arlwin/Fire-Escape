extends CanvasLayer

onready var global = get_node("/root/Global")

signal reset()
signal pause(state)

onready var healthBar = $TopContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/HealthBar
onready var roomsVal = $TopContainer/HBoxContainer/MarginContainer/HBoxContainer/RoomsValue

func _process(delta):
	$Pause.visible = global.paused
	if Input.is_action_just_pressed("ui_cancel"):
		global.paused = !global.paused
		emit_signal("pause", global.paused)

func _ready():
	$Pause.hide()
	pass # Replace with function body.

func setHealth(value, total):
	healthBar.value = value
	healthBar.max_value = total
	pass

func setRooms(value):
	roomsVal.text = str(value)
	pass

func showGameOver():
	$TopContainer.hide()
	$DialogBox.hide()
	$GameOver.visible = true
	pass

func _on_PlayAgain_button_up():
	emit_signal("reset")
	pass # Replace with function body.

func _on_Quit_button_up():
	get_tree().quit()
	pass # Replace with function body.
