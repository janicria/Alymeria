class_name SummonStats extends Stats

@export var name: String
@export_multiline var description: String
@export var card_type: Card.Type
@export var base_action: SummonAction
@export var card_action: SummonAction
@export var special_action: SummonAction

var summon: Summon
