extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 140

func _physics_process(_delta: float) -> void:
	handle_input()
	velocity = direction * speed
	move_and_slide()


func handle_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x:
		$AnimatedSprite2D.animation = 'right'
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y:
		$AnimatedSprite2D.animation = 'up' if direction.y < 0 else 'down'
	else:
		$AnimatedSprite2D.animation = 'down'
