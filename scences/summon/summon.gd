class_name Summon extends Area2D

@export var stats: SummonStats

@onready var texture: TextureRect = %Texture
@onready var stats_ui: StatsUI = %StatsUI
@onready var status_handler: StatusHandler = %StatusHandler
@onready var modifier_handler: ModifierHandler = %ModifierHandler


func _ready() -> void:
	stats = stats.create_instance()
	texture.texture = stats.art
	
	#stats.base_action.owner = self
	#stats.card_action.owner = self
	#stats.special_action.owner = self
	#status_handler.status_owner = self
	
	if !stats.stats_changed.is_connected(stats_ui.update_stats):
		stats.stats_changed.connect(stats_ui.update_stats.bind(stats))
	stats_ui.update_stats(stats)


func take_damage(damage : int, modify_damage := true) -> void:
	if stats.health <= 0: return
	Data.damage_dealt += damage
	
	var modified_damage := modifier_handler.get_modified_value(damage, Modifier.Type.DMG_TAKEN)
	if !modify_damage: modified_damage = damage
	
	var tween := create_tween()
	tween.tween_callback(get_tree().current_scene.shaker.shake.bind(self, 12, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func()->void:
			if stats.health <= 0:
				death_animation())


func death_animation(repeats := 3) -> void:
	var death_tween := create_tween()
	# So enemies won't be stuck attacking dying summons
	remove_from_group("summons")
	death_tween.tween_callback(get_tree().current_scene.shaker.shake.bind(self, 10, 0.15))
	death_tween.tween_interval(0.2)
	
	death_tween.finished.connect(
		func()->void:
			# Repeats damage anim for more effect
			for i in repeats: death_animation(repeats - 1)
			if !repeats:
				# Await prevents death anim from ending early
				await get_tree().create_timer(0.2, false).timeout
				#Events.summon_died.emit(self)
				queue_free())
	
