class_name SummonStats extends Stats

enum SpecialActionType {HEALTH_LOST, DEATH, STATUS_GAINED, STATUS_REMOVED}

@export var name: String
@export_multiline var description: String
@export_multiline var flavour_text: String = "todo me :3"
@export var base_action: SummonAction
@export var card_action: SummonAction
@export var card_action_type: Card.Type
@export var special_action: SummonAction
@export var special_action_type: SpecialActionType

var summon: Summon


func take_damage(damage: int, status: Status = null) -> bool:
	var initial_health := health
	var result := super.take_damage(damage)
	if initial_health > health:
		if special_action_type == SpecialActionType.HEALTH_LOST:
			special_action.play()
		if status != null:
			var status_effect := StatusEffect.new()
			status_effect.status = status
			status_effect.execute([summon])
	return result
