class_name SummonAction extends Resource

signal finished

enum Type {BASE, CARD, SPECIAL}
enum Targets {SINGLE, PLAYER, SELF, ENEMIES, RANDOM_ENEMY, ALLIES, EVERYONE}

@export var type: Type
@export var target_type: Targets
@export var sound: AudioStream

var owner: Summon


func setup() -> void:
	if type == Type.CARD:
		Events.player_card_played.connect(
			func(card:Card)->void:
				if card.type == owner.stats.card_action_type:
					play())


func get_modified_damage(damage: int, target: Node) -> int:
		var modified_damage := owner.modifier_handler.get_modified_value(damage, Modifier.Type.DMG_DEALT)
		return target.modifier_handler.get_modified_value(modified_damage, Modifier.Type.DMG_TAKEN)


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
		Targets.RANDOM_ENEMY:
			targets = [Data.get_tree().get_nodes_in_group("enemies").pick_random()]
		Targets.ALLIES:
			targets = Data.get_tree().get_nodes_in_group("summon")
			targets.append(Data.get_tree().get_first_node_in_group("player"))
		Targets.EVERYONE:
			targets = [Data.get_tree().get_first_node_in_group("enemies")]
			targets.append_array(Data.get_tree().get_nodes_in_group("summon"))
			targets.append(Data.get_tree().get_first_node_in_group("player"))
	
	for target in targets:
		apply_effects(target)
	await Data.get_tree().create_timer(0.1).timeout
	finished.emit()


func apply_effects(_target: Node) -> void:
	pass
