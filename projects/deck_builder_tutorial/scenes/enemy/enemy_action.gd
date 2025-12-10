class_name EnemyAction
extends Node

enum Type {
	CONDITIONAL,
	CHANCE_BASED
} 

@export var type: Type
@export_range(0., 10.) var chance_weight := 0.

@onready var accumulated_weight := 0.

var enemy: Enemy
var target: Node2D


func is_performable() -> bool:
	return false


func perform_action():
	pass
