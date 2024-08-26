class_name EnemyCard
extends Resource

enum Type {ATTACK, BARRIER, LARGE_BARRIER, DRAW, ENERGY, BUFF, DEBUFF, SPAWN, UNKNOWN}
enum Targets {SINGLE, SELF, ENEMIES, ALLIES, EVERYONE}

@export var type: Type
@export var amount: int
@export var repeats := 1
@export var cost := 1
@export var weight :int
@export var targets: Targets
@export var health: int = 0
@export var optional_desc: String
@export var optional_icon: Texture


var icon_dict := {
	Type.ATTACK: preload("res://assets/art/tile_0103.png"),
	Type.BARRIER: preload("res://assets/art/tile_0101.png"),
	Type.LARGE_BARRIER: preload("res://assets/art/tile_0102.png"),
	Type.DRAW: preload("res://assets/cards/deck.png"),
	Type.ENERGY: preload("res://assets/art/tile_0113.png"),
	Type.BUFF: preload("res://assets/art/tile_0126.png"),
	Type.DEBUFF: preload("res://assets/art/tile_0127.png"),
	Type.SPAWN: preload("res://assets/art/tile_0122.png"),
	Type.UNKNOWN: preload("res://assets/art/rarity.png")
}

var tooltip_text_dict := {
	Type.ATTACK: "[color=ff0000]attack for ",
	Type.BARRIER: "regain a small amount of [color=0044ff]barrier[/color]",
	Type.LARGE_BARRIER: "regain a large amount of [color=0044ff]barrier[/color]",
	Type.DRAW: "draw ",
	Type.ENERGY: "replenish ",
	Type.BUFF: "apply ",
	Type.DEBUFF: "apply ",
	Type.SPAWN: "spawn an ally",
	Type.UNKNOWN: "do something unknown"
}

var SFX_dict := {
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
