class_name Player
extends Node2D

@export var stats: CharacterStats:
	set = set_character_stats
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_ui: StatusUI = $StatsUI


func set_character_stats(value: CharacterStats):
	stats = value
	
	# 在检查器中初始话会调用 setter 函数
	# 需要信号防止被连接两次
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()


func update_player():
	if not stats is CharacterStats:
		return
	
	# setter 函数中调用了该函数，繁殖在节点准备好之前就调用这个函数
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	update_stats()


func update_stats():
	stats_ui.update_status(stats)


func take_damage(damage: int):
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)

	if stats.health <= 0:
		queue_free()
	
