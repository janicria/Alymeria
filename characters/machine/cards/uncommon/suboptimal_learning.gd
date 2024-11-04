extends Card

const SUBOPTIMAL := preload("res://effects/status/suboptimal.tres")

func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var suboptimal := SUBOPTIMAL.duplicate()
	suboptimal.stacks = 1
	status_effect.status = suboptimal
	status_effect.execute(targets)


func get_status_or_effect_text(text: String) -> String:
	if text == "suboptimal":
		return (str(Data.StatusDescriptions.get(text)) % (
			[Data.get_tree().get_node_count_in_group("enemies"), 
			Data.get_tree().get_node_count_in_group("enemies")])) + "\n"
	return ""
