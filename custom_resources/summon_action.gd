class_name SummonAction extends Resource

signal finished

enum Type {BASE, CARD, SPECIAL}
enum Targets {SINGLE, PLAYER, SELF, ENEMIES, ALLIES, EVERYONE}

@export var type: Type
@export var target_type: Targets

var owner: Summon


func setup() -> void:
	if type == Type.BASE:
		Events.update_battle_state.connect(
			func(_state: Battle.State)->void:
				play())
	elif type == Type.CARD:
		Events.player_card_played.connect(
			func(card:Card)->void:
				if card.type == owner.card_type:
					play())


func play() -> void:
	var targets: Array[Node]
	match target_type:
		Targets.SINGLE:
			targets = [Data.get_tree().get_first_node_in_group("enemies")]
		Targets.PLAYER:
			targets = [Data.get_tree().get_first_node_in_group("player")]
		Targets.SELF:
			targets = [owner]
		Targets.ENEMIES:
			targets = Data.get_tree().get_nodes_in_group("enemies")
		Targets.ALLIES:
			targets = Data.get_tree().get_nodes_in_group("summon")
			targets.append(Data.get_tree().get_first_node_in_group("player"))
		Targets.EVERYONE:
			targets = [Data.get_tree().get_first_node_in_group("enemies")]
			targets.append_array(Data.get_tree().get_nodes_in_group("summon"))
			targets.append(Data.get_tree().get_first_node_in_group("player"))
	
	apply_effects(targets, null)


func apply_effects(_targets: Array[Node], _modifiers: ModifierHandler) -> void:
	pass
