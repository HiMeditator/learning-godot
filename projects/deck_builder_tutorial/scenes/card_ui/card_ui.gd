class_name CardUI
extends Control

@warning_ignore("unused_signal")
signal reparent_requested(which_card_ui: CardUI)

const BASE_STYLEBOX := preload("res://scenes/card_ui/card_base_stylebox.tres")
const DRAG_STYLEBOX := preload("res://scenes/card_ui/card_dragging_stylebox.tres")
const HOVER_STYLEBOX := preload("res://scenes/card_ui/card_hover_stylebox.tres")

@export var card: Card:
	set = _set_card
@export var char_stats: CharacterStats:
	set = _set_char_stats


@onready var panel: Panel = $Panel
@onready var cost: Label = $Cost
@onready var icon: TextureRect = $Icon
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine
@onready var targets: Array[Node] = []
@onready var original_index := self.get_index()


var parent: Control
var tween: Tween
var playable := true: # 基于法力是否可以打出
	set = _set_playable
var disabled := false


func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aiming_started)
	Events.card_drag_started.connect(_on_card_drag_or_aiming_started)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)


func animate_to_position(new_position: Vector2, duration: float):
	tween = create_tween().set_trans(Tween.TRANS_CIRC).\
	set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position", new_position, duration)


func play():
	if not card:
		return
	
	card.play(targets, char_stats)
	queue_free()


func _input(event: InputEvent):
	card_state_machine.on_input(event)


func _on_gui_input(event: InputEvent):
	card_state_machine.on_gui_input(event)


func _on_mouse_entered():
	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _set_card(value: Card):
	if not is_node_ready():
		await ready
	
	card = value
	cost.text = str(card.cost)
	icon.texture = card.icon


func _set_playable(value: bool):
	playable = value
	if not playable:
		cost.add_theme_color_override("font_color", Color.RED)
		icon.modulate = Color(1, 1, 1, 0.5)
	else:
		cost.remove_theme_color_override("font_color")
		icon.modulate = Color(1, 1, 1, 1)


func _set_char_stats(value: CharacterStats):
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		IO_Utils.print_log(0, self, " append area target: ", area)
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	IO_Utils.print_log(0, self, " erase area target: ", area)
	targets.erase(area)


func _on_card_drag_or_aiming_started(used_card: CardUI):
	if used_card == self:
		return
	disabled = true


func _on_card_drag_or_aim_ended(_card: CardUI):
	disabled = false
	self.playable = char_stats.can_play_card(card)


func _on_char_stats_changed():
	self.playable = char_stats.can_play_card(card)
