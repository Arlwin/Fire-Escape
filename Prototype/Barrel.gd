extends RigidBody2D

export var DAMAGE = 5

func _ready():
	pass # Replace with function body.

func _process(delta):
	for body in get_colliding_bodies():
		if (body.get_name() == 'Floor'):
			gravity_scale = 100
	pass
