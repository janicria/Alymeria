class_name EnemyCard
extends Resource

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

const icon_dict := {
	Type.ATTACK: preload("res://assets/art/objects/tile_0103.png"),
	Type.BARRIER: preload("res://assets/art/objects/tile_0101.png"),
	Type.LARGE_BARRIER: preload("res://assets/art/objects/tile_0102.png"),
	Type.DRAW: preload("res://assets/ui/cards/deck.png"),
	Type.ENERGY: preload("res://assets/art/objects/tile_0113.png"),
	Type.BUFF: preload("res://assets/art/objects/tile_0126.png"),
	Type.DEBUFF: preload("res://assets/art/objects/tile_0127.png"),
	Type.SPAWN: preload("res://assets/art/characters/tile_0122.png"),
	Type.UNKNOWN: preload("res://assets/ui/rarity.png")
}

const SFX_dict := {
	Type.ATTACK: preload("res://assets/SFX/enemy_attack.ogg"),
	Type.BARRIER: preload("res://assets/SFX/enemy_block.ogg"),
	Type.LARGE_BARRIER: preload("res://assets/SFX/enemy_block.ogg"),
	Type.DRAW: preload("res://assets/SFX/enemy_block.ogg"),
	Type.ENERGY: preload("res://assets/SFX/enemy_block.ogg"),
	Type.BUFF: preload("res://assets/SFX/slash.ogg"),
	Type.DEBUFF: preload("res://assets/SFX/slash.ogg"),
	Type.SPAWN: preload("res://assets/SFX/slash.ogg"),
	Type.UNKNOWN: preload("res://assets/SFX/slash.ogg")
}


func custom_play() -> void:
	pass
