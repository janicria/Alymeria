class_name Summon extends Area2D
# Really just a summon 2d, everything important is stored in stats

signal damaged

const SUMMON = preload("res://scences/summon/summon.tscn")
const CURSOR = preload("res://assets/misc/cursor.png")
const BUBBLE_CURSOR = preload("res://assets/misc/bubble_cursor.png")

@export var stats: SummonStats : set = setup_stats

@onready var texture: TextureRect = %Texture
@onready var stats_ui: StatsUI = %StatsUI
@onready var status_handler: StatusHandler = %StatusHandler
@onready var modifier_handler: ModifierHandler = %ModifierHandler


# Trust me, this is needed to all stats to work correctly
func setup_stats(value: SummonStats) -> void:
	stats = value.create_instance()
	if !is_node_ready(): await ready
	
	texture.texture = stats.art
	status_handler.status_owner = self
	stats.setup(self)
	
	if !stats.stats_changed.is_connected(stats_ui.update_stats):
		stats.stats_changed.connect(stats_ui.update_stats.bind(stats))
	
	stats_ui.update_stats(stats)


static func summon(new_stats: SummonStats) -> Summon:
	var new_summon := SUMMON.instantiate()
	new_summon.stats = new_stats
	Data.summon_handler.add_child(new_summon)
	new_summon.add_to_group("summons", true)
	new_summon.global_position = Vector2(
		140+(50*(Data.summon_handler.get_child_count()+1)), 
		randi_range(150, 170))
	return new_summon


func do_turn() -> void:
	stats.barrier = clamp((stats.barrier -10), 0, 999)
	status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)


func take_damage(damage: int, status: Status = null) -> void:
	# Shouldn't even get attack when dying, group check is there because why not yk?
	if !is_in_group("summons") || !enemies_are_alive(): return
	
	var modified_damage := modifier_handler.get_modified_value(damage, Modifier.Type.DMG_TAKEN)
	
	var tween := create_tween()
	tween.tween_callback(
		get_tree()
		.current_scene.shaker.shake.bind(self, 12, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage, status))
	tween.tween_callback(func()->void: damaged.emit()) #FIXME: Gets played 4 times
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func()->void:
			if stats.health <= 0 && enemies_are_alive():
				death_animation())


func death_animation(repeats := 3) -> void:
	# So enemies don't attack dying summons
	remove_from_group("summons")
	
	var death_tween := create_tween()
	death_tween.tween_callback(
		get_tree()
		.current_scene.shaker.shake.bind(self, 30, 0.2))
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


# Prevents tween from being active after summon is freed
func enemies_are_alive() -> bool:
	return get_tree().get_nodes_in_group("enemies").all(
		func(enemy: Enemy) -> bool:
			return enemy.is_alive)


func _on_texture_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Data.bestiary.show_menu(
			[stats.name, stats.art, "\nActions\n\n%s" % stats.description, stats.flavour_text], 
			false)


func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(BUBBLE_CURSOR)


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(CURSOR)
