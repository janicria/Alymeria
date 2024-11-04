class_name Card extends Resource

enum Type {PHYSICAL, INTERNAL, LOOPED, STATUS, MALWARE, SUMMON}
enum Rarity {COMMON, UNCOMMON, RARE, STATUS, PURPLE}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, RANDOM, EVERYONE, SUMMON}
enum Upgrade {NONE, REFINED, ENHANCED}

@export_group("Attributes")
@export var name: String
@export var type: Type
@export var rarity: Rarity
@export var target: Target
@export var repeats := 1
@export var cost : int : set = set_cost
@export var statuses: Array[CardStatus]

@export_group("Visuals")
@export var sound : AudioStream
@export_multiline var tooltip_text : String
@export var effects: Array[String]

var cardui: CardUI
var upgrade: Upgrade
var unique_id := randi()
var fully_played := false
var cache_cost: int : set = set_cache_cost


func _to_string() -> String:
	return cardui.stats.call()


func set_cache_cost(_value: int) -> void:
	match rarity:
		Card.Rarity.COMMON: cache_cost = 10
		Card.Rarity.UNCOMMON: cache_cost = 15
		Card.Rarity.RARE: cache_cost = 30
		Card.Rarity.STATUS: cache_cost = 0
		Card.Rarity.PURPLE: cache_cost = 50
	if upgrade != Upgrade.NONE: cache_cost += 5
	if has_status("singular"): cache_cost = 10


func set_cost(value: int) -> void:
	cost = clampi(value, 0, 99)


func get_tooltip_text(_player_mods: ModifierHandler, _enemy_mods: ModifierHandler) -> String:
	return tooltip_text


# Status should be part of the card not cardui
func has_status(status_name: String) -> bool:
	for status in statuses:
		if status.name == status_name:
			return true
	return false


func add_status(status: CardStatus) -> void:
	if !statuses.has(status):
		statuses.append(status)


func remove_status(status: CardStatus) -> void:
	if statuses.has(status):
		statuses.erase(status)


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY or target == Target.SUMMON


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if !targets:
		return []
	
	# Scene tree
	var tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies") + tree.get_nodes_in_group("summons")
		_: return []


func play(targets : Array[Node], modifiers: ModifierHandler) -> void:
	fully_played = false
	Events.player_card_played.emit(self) 
	Data.character.memory -= cost
	
	if is_single_targeted(): 
		apply_effects(targets, modifiers)
	else: 
		apply_effects(_get_targets(targets), modifiers)


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass


func get_status_or_effect_text(_name: String) -> String:
	return "Status text not found"


func drawn() -> void:
	pass


func cached() -> void:
	pass
