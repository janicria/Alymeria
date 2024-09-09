class_name Summon
extends Area2D

const ARROW_OFFSET := 8

@export var stats: EnemyStats : set = set_summon_stats

@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var arrow : Sprite2D = $Arrow
@onready var stats_ui : StatsUI = $StatsUI


func set_summon_stats(value : EnemyStats) -> void:
	stats = value.create_instance()
	
	if !stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_summon()


func setup_ai() -> void:
	pass

func update_stats() -> void:
	stats_ui.update_stats(stats)


func update_summon() -> void:
	if !stats is Stats:
		return
	
	if !is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	arrow.position = Vector2.UP * (sprite_2d.get_rect().size.y / 2 + ARROW_OFFSET)
	setup_ai()
	update_stats()


func do_turn() -> void:
	stats.barrier -= 10
	if stats.barrier < 0:
		stats.barrier = 0


func take_damage(damage : int) -> void:
	if stats.health <= 0:
		return
	
	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 12, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func()->void:
			if stats.health <= 0:
				death_animation(4)
	)


func death_animation(repeats : int) -> void:
	remove_from_group("summons")
	Events.enemy_reload_targets.emit()
	
	
	var death_tween := create_tween()
	death_tween.tween_callback(Shaker.shake.bind(self, 10, 0.15))
	death_tween.tween_interval(0.2)
	
	death_tween.finished.connect(
		func()->void:
			for i in repeats:
				death_animation(repeats - 1)
	)
	if !repeats:
		queue_free()


func _on_area_entered(_area) -> void:
	arrow.show()


func _on_area_exited(_area) -> void:
	arrow.hide()


func _on_mouse_entered() -> void:
	if stats.id == "AttackSentry":
		Events.card_tooltip_requested.emit("[center]Attack Sentry - When a [color=800080]Summon[/color][color=ff0000] Attack[/color] is played for it, it deals [color=ff0000]6 damage[/color] to a random enemey. When a [color=800080]Summon[/color][color=0044ff] Ability[/color] is played for it, all allies gain one damage up
Damage up - Attacks or Cards deal one additional [color=ff0000]damage[/color][/center]")


func _on_mouse_exited() -> void:
	if stats.id == "AttackSentry":
		Events.tooltip_hide_requested.emit()
