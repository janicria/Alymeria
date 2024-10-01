class_name Suboptimal
extends Status

const DMG_UP := preload("res://effects/status/damage_up.tres")

func apply_status(target: Node) -> void:
	print("sub for %s" % target)
	
	var status_effect := StatusEffect.new()
	var damage_up := DMG_UP.duplicate()
	damage_up.stacks = target.get_tree().get_node_count_in_group("enemies")
	status_effect.status = damage_up
	status_effect.execute([target])
	GameManager.character.heal(-1 * target.get_tree().get_node_count_in_group("enemies"))
	GameManager.character.mana -= 1
	
	status_applied.emit(self)
