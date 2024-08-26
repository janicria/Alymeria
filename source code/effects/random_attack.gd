class_name RandomAttack
extends Node

var id : String

func _ready() -> void:
	Events.enemy_give_enemies.connect(_on_enemy_give_enemies)


func start(enemies : bool, summons : bool, damage :int, repeats : int, original_id : String) -> void:
	Events.enemy_find_enemies.emit(original_id, damage, repeats)


func _on_enemy_give_enemies(targets : Array[Node], original_id : String, damage : int, repeats : int) -> void:
	if original_id == "AttackSentry":
		var target = targets
		target.shuffle()
		for Node2D in target:
			if target.size() != 1:
				target.pop_back()
		var damage_effect := DamageEffect.new()
		damage_effect.amount = damage
		damage_effect.execute(target)
