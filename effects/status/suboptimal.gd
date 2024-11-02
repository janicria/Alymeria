extends Status

const DMG_UP := preload("res://effects/status/damage_up.tres")
const MEMORY_DOWN := preload("res://effects/status/memory_down.tres")

var enemy_count := func()->int:
	return Data.get_tree().get_node_count_in_group("enemies")


func initalise_target(target: Node) -> void:
	var status_effect := StatusEffect.new()
	var memory_down := MEMORY_DOWN.duplicate()
	memory_down.stacks = 1
	status_effect.status = memory_down
	status_effect.execute([target])


func apply_status(target: Node) -> void:	
	var status_effect := StatusEffect.new()
	var damage_up := DMG_UP.duplicate()
	damage_up.stacks = enemy_count.call()
	status_effect.status = damage_up
	status_effect.execute([target])
	Data.character.heal(-1 * enemy_count.call())
	
	status_applied.emit(self)


func get_tooltip() -> String:
	return tooltip % [enemy_count.call(), enemy_count.call()]
