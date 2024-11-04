extends Card

const HIDDEN = preload("res://effects/status/hidden.tres")

var base_amount := 1


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var hidden := HIDDEN.duplicate()
	hidden.duration = base_amount
	status_effect.status = hidden
	status_effect.execute(targets)


func get_tooltip_text(_player_mods: ModifierHandler, _enemy_mods: ModifierHandler) -> String:
	return tooltip_text % base_amount
