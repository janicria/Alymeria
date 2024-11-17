class_name Modifier extends Node

enum Type {DMG_DEALT, BARRIER_GAINED, DMG_TAKEN, NULL}

@export var type: Type


func get_value(source_id: String) -> ModifierValue:
	for modifier_value: ModifierValue in get_children():
		if modifier_value.soucre_id == source_id:
			return modifier_value
	return null


func add_new_value(value_to_add: ModifierValue) -> void:
	var current_value := get_value(value_to_add.soucre_id)
	if !current_value: 
		add_child(value_to_add)
	else:
		current_value.percent_value = value_to_add.percent_value
		current_value.flat_value = value_to_add.flat_value


func remove_value(source_id: String, all := false) -> void:
	for modifier_value: ModifierValue in get_children():
		if modifier_value.soucre_id == source_id or all: 
			modifier_value.queue_free()


func get_modified_value(base: int) -> int:
	var percent_result := 1.0
	var flat_result := base
	
	for modifier_value: ModifierValue in get_children():
		if modifier_value.type == ModifierValue.Type.FLAT:
			flat_result += modifier_value.flat_value
		elif modifier_value.type == ModifierValue.Type.PERCENT:
			percent_result += modifier_value.percent_value
	
	# TODO: Reference mods rounding up to players
	return ceili(flat_result * percent_result)
