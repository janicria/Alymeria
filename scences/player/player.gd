class_name Player
extends Node2D

@export var stats : CharacterStats : set = set_character_stats

@onready var sprite_2d : Sprite2D = %Sprite2D
@onready var stats_ui : StatsUI = %StatsUI
@onready var damage_counter: RichTextLabel = %DamageCounter

var damage_count: int

func _ready() -> void:
	Events.update_player_dmg_counter.connect(update_damage_counter)


func set_character_stats(value : CharacterStats) -> void:
	stats = value
	
	if !stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()


func update_player() -> void:
	if !stats is CharacterStats:
		return
	
	if !is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	
	update_stats()


func update_stats() -> void:
	stats_ui.update_stats(stats)


func update_damage_counter(amount: int, reset: bool) -> void:
	if reset: damage_count = 0
	damage_counter.visible = damage_count != 0
	damage_count += amount
	damage_counter.text = "[center][color=AB3321] %s [/color][/center]" % str(damage_count) 


func take_damage(damage : int) -> void:
	if stats.health <= 0:
		return
	
	stats.take_damage(damage)
	
	if stats.health <= 0:
		Events.player_died.emit()
		queue_free()
