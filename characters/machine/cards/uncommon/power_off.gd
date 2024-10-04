extends Card

var base_amount := 0


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	var damage_effect := DamageEffect.new()
	base_amount = GameManager.character.draw_pile.cards.size()
	damage_effect.amount = modifiers.get_modified_value(base_amount, Modifier.Type.DMG_DEALT)
	damage_effect.sound = sound
	damage_effect.execute(targets)
