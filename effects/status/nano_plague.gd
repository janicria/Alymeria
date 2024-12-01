extends Status

const NANO_PLAGUE = preload("res://effects/status/nano_plague.tres")

var active := true


func apply_status(target: Node) -> void:
	if !active: 
		active = true
		return
	
	target.take_damage(ceili(stacks * 0.8))
	
	# Creating new status
	var status_effect := StatusEffect.new()
	var nano_plauge := NANO_PLAGUE.duplicate()
	nano_plauge.stacks = ceili(stacks * 0.2)
	status_effect.status = nano_plauge
	nano_plauge.active = false
	
	# Applying new status
	match target.get_groups()[-1]:
		"player": 
			status_effect.execute(target.get_tree().get_nodes_in_group("summons"))
		"summons":
			status_effect.execute(target.get_tree().get_nodes_in_group("summons").filter(
				func(summon:Summon)->bool: return summon != target))
			status_effect.execute([target.get_tree().get_first_node_in_group("player")])
		"enemies":
			status_effect.execute(target.get_tree().get_nodes_in_group("enemies").filter(
				func(enemy:Enemy)->bool: return enemy != target))
