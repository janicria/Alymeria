class_name Suboptimal
extends Status

const DMG_UP := preload("res://effects/status/damage_up.tres")
const MANA_DOWN := preload("res://effects/status/mana_down.tres")

func initalise_target(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var mana_down := MANA_DOWN.duplicate()
	mana_down.stacks = 1
	status_effect.status = mana_down
	status_effect.execute([target])


func apply_status(target: Node) -> void:	
	var status_effect := StatusEffect.new()
	var damage_up := DMG_UP.duplicate()
	damage_up.stacks = target.get_tree().get_node_count_in_group("enemies")
	status_effect.status = damage_up
	status_effect.execute([target])
	Data.character.heal(-1 * target.get_tree().get_node_count_in_group("enemies"))
	
	status_applied.emit(self)
