extends KinematicBody2D

signal playerHit(value, total)
signal gameOver(done)

export var MOVE_SPEED = 200
export var GRAVITY = 9.8 * 100
export var JUMP_SPEED = -500
export var MAX_HEALTH = 100

var velocity = Vector2()

onready var jump = false
onready var global = get_node("/root/Global")
onready var hit = false
onready var dead = false
onready var crouch = false

func _ready():
	if global.playerVelocity != null:
		velocity = global.playerVelocity
	if global.playerHealth == null:
		global.playerHealth = MAX_HEALTH
	pass # Replace with function body.

func _exit_tree():
	global.playerVelocity = velocity

func get_input():
	velocity.x = 0 if not global.slidingLevel else MOVE_SPEED
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		jump = true
		velocity.y = JUMP_SPEED
	if Input.is_action_pressed('ui_right'):
		$Sprite.flip_h = false
		velocity.x += MOVE_SPEED
	if Input.is_action_pressed('ui_left') and not global.slidingLevel:
		$Sprite.flip_h = true
		velocity.x -= MOVE_SPEED
	if Input.is_action_pressed("ui_down") and not jump:
		crouch = true
	if Input.is_action_just_released("ui_down"):
		crouch = false
	
	if global.slidingLevel:
		if not hit:
			$Sprite.animation = 'slide'
		else:
			$Sprite.animation = 'slide_hit'
		$CollisionShape2D.position.x = 17
		$Area2D/CollisionShape2D.position.x = 17
	else:
		$CollisionShape2D.position.x = -3
		$Area2D/CollisionShape2D.position.x = -3
		if (velocity.y < 0 and jump):
			$Sprite.animation = 'jump' if not hit else 'jump_hit'
		elif (velocity.x == 0):
			if hit:
				$Sprite.animation = 'idle_hit' if not crouch else 'idle_crouch_hit'
			else:
				$Sprite.animation = 'idle' if not crouch else 'idle_crouch'
		else:
			if hit:
				$Sprite.animation = 'run_hit'
			else:
				$Sprite.animation = 'run' if not crouch else 'run_crouch'

func get_collision_height():
	if crouch:
		# Body
		$CollisionShape2D.shape.radius = 18.05
		$CollisionShape2D.shape.height = 28.774
		$CollisionShape2D.position = Vector2(-4.414, 17.868)
		
		#Area
		$Area2D/CollisionShape2D.shape.extents = Vector2(13, 30)
		$Area2D/CollisionShape2D.position = Vector2(-3, 18)
	else:
		# Body
		$CollisionShape2D.shape.radius = 16.581
		$CollisionShape2D.shape.height = 67.369
		$CollisionShape2D.position = Vector2(-5.045, 2.102)
		
		#Area
		$Area2D/CollisionShape2D.shape.extents = Vector2(13, 42)
		$Area2D/CollisionShape2D.position = Vector2(-3, 6)
	pass
	
func _physics_process(delta):
	if not dead:
		get_input()
		get_collision_height()
		velocity.y += GRAVITY * delta
		if jump and is_on_floor():
			jump = false
		velocity = move_and_slide(velocity, global.playerUp)

func _on_Area2D_body_entered(body):
	if 'Barrel' in body.get_name() or 'Fire' in body.get_name():
		hit = true
		global.playerHealth -= body.DAMAGE
		emit_signal("playerHit", global.playerHealth, MAX_HEALTH)
		if global.playerHealth <= 0:
			$DeathTimer.start()
			dead = true
			emit_signal("gameOver", false)
		$HitTimer.start()
	pass # Replace with function body.

func _on_HitTimer_timeout():
	hit = false
	pass # Replace with function body.
	
func _on_Sprite_animation_finished():
	if $Sprite.animation == 'die':
		emit_signal("gameOver", true)
	pass # Replace with function body.

func _on_DeathTimer_timeout():
	$Sprite.animation = 'die'
