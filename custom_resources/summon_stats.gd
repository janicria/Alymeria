class_name SummonStats extends Stats

@export var name: String
@export_multiline var description: String
@export var card_type: Card.Type
@export var base_action: SummonAction
@export var card_action: SummonAction
@export var special_action: SummonAction

var summon: Summon


func take_damage(damage: int, status: Status = null) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health && status != null:
		var status_effect := StatusEffect.new()
		status_effect.status = status
		status_effect.execute([summon])
