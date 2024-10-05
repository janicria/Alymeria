extends Card

const CANCEL := preload("res://effects/status/cancel.tres")

var base_damage := 0


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var status_effect := StatusEffect.new()
	var damage_effect := DamageEffect.new()
	var cancel := CANCEL.duplicate()
	base_damage = GameManager.character.draw_pile.cards.size()
	damage_effect.amount = modifiers.get_modified_value(base_damage, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	cancel.duration = 2
	status_effect.status = cancel
	damage_effect.execute(targets)
	status_effect.execute(GameManager.get_tree().get_nodes_in_group("player"))
