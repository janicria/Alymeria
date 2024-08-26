class_name RandomEnemyAttackDouble
extends Card

var new_targets : Array[Node]
var number_of_repeats := 2


func apply_effects(targets: Array[Node]) -> void:
	if number_of_repeats == self.repeats:
		Events.battle_give_enemies.connect(_on_battle_give_enemies)
		Events.battle_find_enemies.emit()
		for Summon in targets:
			targets.erase(Summon)
		
	else:
		var damage_effect := DamageEffect.new()
		damage_effect.amount = 4
		damage_effect.sound = sound
		damage_effect.execute(new_targets)
		if number_of_repeats:
			Events.battle_find_enemies.emit()
		else:
			number_of_repeats = 2


func _on_battle_give_enemies(targets : Array[Node]) -> void:
	number_of_repeats -= 1
	new_targets = targets
	new_targets.shuffle()
	for Node2D in new_targets:
		if new_targets.size() != 1:
			new_targets.pop_back()
	apply_effects(new_targets)
