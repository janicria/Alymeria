class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, HAVEN, SHOP, ELITE, BOSS}

@export var type: Type
@export var row: int
@export var column: int
@export var position: Vector2
@export var next_rooms: Array[Room]
@export var selected := false
# Only used by combat encounters
@export var battle_stats: BattleStats


func _to_string() -> String:
	return "%s (%s)" % [column, Type.keys()[type][0]]
