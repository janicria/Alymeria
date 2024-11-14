class_name EnemyCard extends Resource

enum Type {ATTACK, BARRIER, LARGE_BARRIER, DRAW, ENERGY, BUFF, DEBUFF, SPAWN, UNKNOWN}
enum Targets {SINGLE, SELF, ENEMIES, ALLIES, EVERYONE}

@export var type: Type
@export var amount: int
@export var repeats := 1
# Spawns / buffs / debuffs shouldn't use custom_amount (a buff with an amount of 2 equals 2 buffs)
@export var custom_amount: String
@export var cost := 1
@export var weight :int
@export var targets: Targets
@export var health: int = 0

var cumulative_weight := 0
var cardui: EnemyCardUI

const icon_dict := {
	Type.ATTACK: preload("res://assets/objects/sword_size1.png"),
	Type.BARRIER: preload("res://assets/objects/barrier_small.png"),
	Type.LARGE_BARRIER: preload("res://assets/objects/barrier_large.png"),
	Type.DRAW: preload("res://assets/ui/cards/deck.png"),
	Type.ENERGY: preload("res://assets/objects/tile_0113.png"),
	Type.BUFF: preload("res://assets/objects/tile_0126.png"),
	Type.DEBUFF: preload("res://assets/objects/tile_0127.png"),
	Type.SPAWN: preload("res://assets/characters/tile_0122.png"),
	Type.UNKNOWN: preload("res://assets/ui/cards/orb.png")
}

const SFX_dict := {
	Type.ATTACK: preload("res://assets/sfx/enemy_attack.ogg"),
	Type.BARRIER: preload("res://assets/sfx/enemy_block.ogg"),
	Type.LARGE_BARRIER: preload("res://assets/sfx/enemy_block.ogg"),
	Type.DRAW: preload("res://assets/sfx/enemy_block.ogg"),
	Type.ENERGY: preload("res://assets/sfx/enemy_block.ogg"),
	Type.BUFF: preload("res://assets/sfx/slash.ogg"),
	Type.DEBUFF: preload("res://assets/sfx/slash.ogg"),
	Type.SPAWN: preload("res://assets/sfx/slash.ogg"),
	Type.UNKNOWN: preload("res://assets/sfx/slash.ogg")
}


func custom_play(_final_targets: Array[Node]) -> void:
	pass


func get_tooltip() -> String:
	return "Pls give me a tooltip"
