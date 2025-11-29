extends Node2D

@export var drone_scene: PackedScene

func _ready() -> void:
	var drone1: CharacterBody2D = drone_scene.instantiate()
	var drone2: CharacterBody2D = drone_scene.instantiate()
	drone1.position = Vector2(60, -80)
	drone2.position = Vector2(60, 80)
	$Entities.add_child(drone1)
	$Entities.add_child(drone2)
	
