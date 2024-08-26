class_name EnemyActionPicker
extends Node

@export var enemy : Enemy : set = _set_enemy
@export var target : Node2D : set = _set_target

@export var moveset: String = "pinch, fortify, hide"

@onready var total_weight := 0.0


func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)
	Events.enemy_reload_targets.connect(_on_enemy_action_completed)
	_on_enemy_action_completed(null)
	setup_chances()


func _on_enemy_action_completed(_enemy : Enemy) -> void:
	if get_tree().has_group("summons"):
		target = get_tree().get_first_node_in_group("summons")
	else:
		target = get_tree().get_first_node_in_group("player")
	
	for action in get_children():
		action.target = target


func get_action() -> EnemyAction:
	var action := get_first_conditional_action()
	if action:
		return action
	
	return get_chance_based_action()


func get_first_conditional_action() -> EnemyAction:
	var action: EnemyAction
	
	for child in get_children():
		action = child
		if !action or action.type != EnemyAction.Type.CONDITIONAL:
			continue
	
		if action.is_performable():
			return action
	
	return null


func get_chance_based_action() -> EnemyAction:
	var action : EnemyAction
	var roll := randf_range(0.0, total_weight)
	
	for child in get_children():
		action = child
		if !action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue
	
		if action.accumulated_weight > roll:
			return action
	
	return null


func setup_chances() -> void:
	var action : EnemyAction
	
	for child in get_children():
		action = child
		if !action or action.type != EnemyAction.Type.CHANCE_BASED:
			continue
		
		total_weight += action.chance_weight
		action.accumulated_weight = total_weight


func _set_enemy(value : Enemy) -> void:
	enemy = value
	
	for action in get_children():
		action.enemy = enemy


func _set_target(value : Node2D) -> void:
	target = value
	
	for action in get_children():
		action.target = target
