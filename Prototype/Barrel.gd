extends RigidBody2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	for body in get_colliding_bodies():
		if (body.get_name() == 'Level'):
			gravity_scale = 100
	pass
