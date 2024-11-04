extends Card

const DAMAGE_UP = preload("res://effects/status/damage_up.tres")

var base_barrier := 60
var chance := 100


func _init() -> void:
	Events.player_card_drawn.connect(func()->void:
		chance = clampi(chance-1, 0, 100))


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	if !randi_range(0, chance):
		var status_effect := StatusEffect.new()
		var barrier_effect := BarrierEffect.new()
		var damage_up := DAMAGE_UP.duplicate()
		barrier_effect.amount = modifiers.get_modified_value(base_barrier, Modifier.Type.BARRIER_GAINED)
		barrier_effect.sound = sound
		damage_up.stacks = 20
		status_effect.status = damage_up
		barrier_effect.execute(targets)
		status_effect.execute(targets)
		Data.character.cards_per_turn += 3
		Data.character.heal(1)


func get_status_or_effect_text(text: String) -> String:
	if text == "lucky_draw":
		return (str(Data.StatusDescriptions.get(text)) % chance) + "\n"
	return ""


func get_tooltip_text(player_mods: ModifierHandler, _enemy_mods: ModifierHandler) -> String:
	if !player_mods: return tooltip_text % base_barrier # When not in a battle
	var modified_dmg := player_mods.get_modified_value(base_barrier, Modifier.Type.BARRIER_GAINED)
	return tooltip_text % modified_dmg
