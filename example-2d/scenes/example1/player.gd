extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 140
var impluse: float = 25


func _physics_process(_delta: float) -> void:
	handle_input()
	velocity = direction * speed
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			IO_Utils.interval_print(collider)
			collider.apply_central_impulse(direction * impluse)


func handle_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x:
		$AnimatedSprite2D.animation = 'right'
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y:
		$AnimatedSprite2D.animation = 'up' if direction.y < 0 else 'down'
	else:
		$AnimatedSprite2D.animation = 'down'


func camera_zoom(zoom: float = 4):
	$Camera2D.zoom = Vector2(zoom, zoom)
	
