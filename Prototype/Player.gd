extends KinematicBody2D

signal playerHit(value, total)

export var MOVE_SPEED = 200
export var GRAVITY = 9.8 * 100
export var JUMP_SPEED = -500
export var MAX_HEALTH = 100

var velocity = Vector2()

onready var jump = false
onready var global = get_node("/root/Global")
onready var hit = false

onready var health = 100

func _ready():
	if global.playerHealth == null:
		global.playerHealth = MAX_HEALTH
	pass # Replace with function body.

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity.x = 0 if not global.slidingLevel else MOVE_SPEED
	
	if Input.is_action_pressed('ui_right'):
		$Sprite.flip_h = false
		velocity.x += MOVE_SPEED
	if Input.is_action_pressed('ui_left') and not global.slidingLevel:
		$Sprite.flip_h = true
		velocity.x -= MOVE_SPEED
		
	if Input.is_action_just_pressed("ui_up"):
		jump = true
		if is_on_floor():
			velocity.y = JUMP_SPEED
	
	if global.slidingLevel:
		$Sprite.animation = 'slide'
		$CollisionShape2D.position.x = 17
		$Area2D/CollisionShape2D.position.x = 17
	else:
		$CollisionShape2D.position.x = -3
		$Area2D/CollisionShape2D.position.x = -3
		if (velocity.y < 0 and jump and not hit):
			$Sprite.animation = 'jump'
		elif (velocity.x == 0 and not hit):
			$Sprite.animation = 'idle'
		elif not hit:
			$Sprite.animation = 'run'

func _physics_process(delta):
	get_input()
	velocity.y += GRAVITY * delta
	if jump and is_on_floor() and velocity.y >= 0:
		jump = false
	velocity = move_and_slide(velocity, Vector2(0, -1))

func _on_Area2D_body_entered(body):
	if 'Barrel' in body.get_name() or 'Fire' in body.get_name():
		hit = true
		$Sprite.animation = $Sprite.animation + '_hit'
		health -= body.DAMAGE
		global.playerHealth = health
		emit_signal("playerHit", health, MAX_HEALTH)
		$HitTimer.start()
	pass # Replace with function body.

func _on_HitTimer_timeout():
	hit = false
	pass # Replace with function body.
