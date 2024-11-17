class_name ModifierValue extends Node

enum Type {PERCENT, FLAT}

@export var type: Type
@export var percent_value: float
@export var flat_value: int
@export var soucre_id: String


static func create_modifier(source_id: String, value_type: Type) -> ModifierValue:
	var modifer := new()
	modifer.soucre_id = source_id
	modifer.type = value_type
	
	return modifer
