class_name SummonAction extends Resource

signal finished

# I WILL REWRITE THIS ENTIRE GAME IN RUST!!!!
enum Type {GREEN, RED, PURPLE, FINISHER}
enum Targets {SINGLE, PLAYER, SELF, ENEMIES, FRONTMOST_ENEMY, ALLIES, EVERYONE, NONE}

@export_group("Main")
@export var type: Type
@export var target: Targets
@export var sound: AudioStream

@export_group("Light")
@export var active_image: Texture2D
@export var inactive_image: Texture2D
@export var pos: Vector2i
@export var size: Vector2i

var stats: SummonStats


func setup() -> void:
	pass


func get_modified_damage(damage: int, mods: ModifierHandler, target: Node) -> int: # Pls overwrite nicely godot
		var modified_damage := mods.get_modified_value(damage, Modifier.Type.DMG_DEALT)
		return target.modifier_handler.get_modified_value(modified_damage, Modifier.Type.DMG_TAKEN)


func play() -> void:
	var targets: Array[Node]
	match target:
		Targets.SINGLE:
			targets = [Data.get_tree().get_nodes_in_group("enemies").pick_random()]
		Targets.PLAYER:
			targets = [Data.get_tree().get_first_node_in_group("player")]
		Targets.SELF:
			targets = [stats.summon]
		Targets.ENEMIES:
			targets = Data.get_tree().get_nodes_in_group("enemies")
		Targets.FRONTMOST_ENEMY:
			targets = [Data.get_tree().get_first_node_in_group("enemies")]
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
