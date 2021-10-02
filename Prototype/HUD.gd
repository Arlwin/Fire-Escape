extends CanvasLayer

onready var healthBar = $TopContainer/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/HealthBar

func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass

func setHealth(value, total):
	healthBar.value = value
	healthBar.max_value = total
	pass
