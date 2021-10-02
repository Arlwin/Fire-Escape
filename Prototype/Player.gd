extends KinematicBody2D

export var MOVE_SPEED = 200
export var GRAVITY = 9.8 * 100
export var JUMP_SPEED = -500
var velocity = Vector2()

var jump = false

func _ready():
	pass # Replace with function body.

func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	velocity.x = 0
	if Input.is_action_pressed('ui_right'):
		$Sprite.flip_h = false
		velocity.x += MOVE_SPEED
	if Input.is_action_pressed('ui_left'):
		$Sprite.flip_h = true
		velocity.x -= MOVE_SPEED
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		jump = true
		velocity.y = JUMP_SPEED

func _physics_process(delta):
	get_input()
	velocity.y += GRAVITY * delta
	if (jump && is_on_floor()):
		jump = false
	move_and_slide(velocity, Vector2(0, -1))
