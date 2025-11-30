extends Node2D

@export var drone_scene: PackedScene


func _ready() -> void:
	create_drone(Vector2(60, -80))
	create_drone(Vector2(60, 80))


func create_drone(pos: Vector2):
	var drone: CharacterBody2D = drone_scene.instantiate()
	drone.position = pos
	$Entities.add_child(drone)


func _on_room_body_entered(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(
		$Entities/Player/Camera2D, "zoom",
		Vector2(6, 6), 1
	)


func _on_room_body_exited(_body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(
		$Entities/Player/Camera2D, "zoom",
		Vector2(4, 4), 1
	)
