class_name Modifier
extends Node

enum Type {DMG_DEALT, BARRIER_GAINED, DMG_TAKEN, NULL}

@export var type: Type


func get_value(source_id: String) -> ModifierValue:
	for modifier_value: ModifierValue in get_children():
		if modifier_value.soucre_id == source_id: return modifier_value
	
	return null


func add_new_value(new_value: ModifierValue) -> void:
	var old_value := get_value(new_value.soucre_id)
	if !old_value:
		add_child(new_value)
	else: # If we already have the value there's no need to add a new child
		old_value.percent_value = new_value.percent_value
		old_value.flat_value = new_value.flat_value
		new_value.queue_free()


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
