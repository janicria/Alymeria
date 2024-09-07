class_name OLDEnemyAI
extends Node

@export var enemy : Enemy : set = _set_enemy
@export var target : Node2D


func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)
	Events.enemy_reload_targets.connect(_on_enemy_action_completed)
	_on_enemy_action_completed(null)


func _on_enemy_action_completed(_enemy : Enemy) -> void:
	if get_tree().has_group("summons"):
		target = get_tree().get_first_node_in_group("summons")
	else:
		target = get_tree().get_first_node_in_group("player")
	
	for action in get_children():
		action.target = target


func _set_enemy(value : Enemy) -> void:
	enemy = value
	
	for action in get_children():
		action.enemy = enemy
