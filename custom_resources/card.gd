class_name Card
extends Resource

enum Type {PHYSICAL, INTERNAL, CHAR, STATUS, CHAR_CURSE}
enum Rarity {COMMON, UNCOMMON, RARE, STATUS}
enum Target {SELF, SINGLE_ENEMY, ALL_ENEMIES, RANDOM, EVERYONE}


@export_group("Card Attributes")
@export var id: String
@export var name: String
@export var type: Type
@export var rarity: Rarity
@export var target: Target
@export var repeats:= 1
@export var cost : int

@export_group("Card Visuals")
@export var sound : AudioStream
@export_multiline var tooltip_text : String
@export_multiline var effect_description : String


var fully_played := false

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if !targets:
		return []
	
	var  tree := targets[0].get_tree()
	
	match target:
		Target.SELF:
			return tree.get_nodes_in_group("player")
		Target.ALL_ENEMIES:
			return tree.get_nodes_in_group("enemies")
		Target.EVERYONE:
			return tree.get_nodes_in_group("player") + tree.get_nodes_in_group("enemies") + tree.get_nodes_in_group("summons")
		_:
			return []


func play(targets : Array[Node], char_stats: CharacterStats) -> void:
	fully_played = false
	Events.card_played.emit(self) 
	char_stats.mana -= cost
	
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))


func apply_effects(_targets: Array[Node]) -> void:
	pass
