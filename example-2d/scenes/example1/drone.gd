extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: float = randf_range(60, 100)
var target_detected: bool = false


func _physics_process(_delta: float) -> void:
	if target_detected:
		update_direction()
	velocity = direction * speed
	move_and_slide()


func update_direction():
	var target: CharacterBody2D = get_tree().get_nodes_in_group('Player')[0]
	direction = (target.position - position).normalized()


func _on_detect_area_body_entered(body: Node2D) -> void:
	print("Drone detects body enter:", body)
	target_detected = true


func _on_detect_area_body_exited(body: Node2D) -> void:
	print("Drone detects body exit:", body)
	target_detected = false
	direction = Vector2.ZERO
