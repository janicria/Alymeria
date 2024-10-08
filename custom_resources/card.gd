class_name Card
extends Resource

enum Type {PHYSICAL, INTERNAL, CHAR, STATUS, CHAR_CURSE}
enum Rarity {COMMON, UNCOMMON, RARE, STATUS}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, RANDOM, EVERYONE}
enum Upgrade {NONE, REFINED, ENHANCED}

# TODO: Ability description const dict (i.e: tooltip_text += DICT["ATTACK"])

@export_group("Attributes")
@export var name: String
@export var type: Type
@export var rarity: Rarity
@export var target: Target
@export var repeats:= 1
@export var cost : int : set = set_cost
@export var exhausts := false

@export_group("Visuals")
@export var sound : AudioStream
@export_multiline var tooltip_text : String
@export_multiline var effect_description : String

var upgrade: Upgrade
var fully_played := false
var cache_cost: int : set = set_cache_cost


func set_cache_cost(_value: int) -> void:
	match rarity:
		0: cache_cost = 10
		1: cache_cost = 15
		2: cache_cost = 30
		3: cache_cost = 0
	if upgrade != Upgrade.NONE: cache_cost += 5


func set_cost(value: int) -> void:
	cost = clampi(value, 0, 99)


func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


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
	Events.card_played.emit(self) 
	GameManager.character.mana -= cost
	
	if is_single_targeted(): 
		apply_effects(targets, modifiers)
	else: 
		apply_effects(_get_targets(targets), modifiers)


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass
