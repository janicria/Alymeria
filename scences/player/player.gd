class_name Player extends Node2D

@export var stats: CharacterStats : set = set_character_stats
@export var handler: PlayerHandeler

@onready var sprite_2d : TextureRect = %Sprite2D
@onready var stats_ui : StatsUI = %StatsUI
@onready var damage_counter: RichTextLabel = %DamageCounter
@onready var status_handler: StatusHandler = %StatusHandler
@onready var modifier_handler: ModifierHandler = %ModifierHandler

var damage_count: int


func _ready() -> void:
	Events.update_player_dmg_counter.connect(update_damage_counter)


func set_character_stats(value : CharacterStats) -> void:
	stats = value
	
	if !stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()
	if !is_node_ready(): await ready
	status_handler.owner = self


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
	damage_count += amount
	damage_counter.visible = damage_count != 0
	damage_counter.text = "[center][color=AB3321]%s[/color][/center]" % damage_count


func take_damage(damage: int, status: Status = null) -> void:
	if stats.health <= 0: return
	
	var tween := create_tween()
	tween.tween_callback(get_tree().current_scene.shaker.shake.bind(self, 12, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage, status))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func()->void:
			if stats.health <= 0:
				Events.update_battle_state.emit(Battle.State.LOSE)
				damage_counter.hide()
				death_animation())


func death_animation(repeats := 3) -> void:
	var death_tween := create_tween()
	death_tween.tween_callback(get_tree().current_scene.shaker.shake.bind(self, 10, 0.15))
	death_tween.tween_interval(0.2)
	
	death_tween.finished.connect(
		func()->void:
			for i in repeats: #Repeats damage anim for more effect
				death_animation(repeats - 1)
			if !repeats:
				# Await prevents death anim from ending early
				await get_tree().create_timer(0.2, false).timeout
				queue_free())
