class_name Summon extends Area2D

const SUMMON = preload("res://scences/summon/summon.tscn")
const CURSOR = preload("res://assets/misc/cursor.png")
const BUBBLE_CURSOR = preload("res://assets/misc/bubble_cursor.png")

@export var stats: SummonStats

@onready var texture: TextureRect = %Texture
@onready var stats_ui: StatsUI = %StatsUI
@onready var status_handler: StatusHandler = %StatusHandler
@onready var modifier_handler: ModifierHandler = %ModifierHandler

func _ready() -> void:
	stats = stats.create_instance()
	texture.texture = stats.art
	
	stats.summon = self
	stats.base_action.owner = self
	stats.card_action.owner = self
	#stats.special_action.owner = self
	status_handler.status_owner = self
	
	if !stats.stats_changed.is_connected(stats_ui.update_stats):
		stats.stats_changed.connect(stats_ui.update_stats.bind(stats))
	
	stats.card_action.setup()
	#stats.special_action.setup()
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
	if stats.health <= 0: return
	Data.damage_dealt += damage
	
	var modified_damage := modifier_handler.get_modified_value(damage, Modifier.Type.DMG_TAKEN)
	
	var tween := create_tween()
	tween.tween_callback(
		get_tree()
		.current_scene.shaker.shake.bind(self, 12, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage, status))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func()->void:
			if stats.health <= 0:
				death_animation())


func death_animation(repeats := 3) -> void:
	if stats.special_action_type == stats.SpecialActionType.DEATH && is_in_group("summons"):
		stats.special_action.play()
		await stats.special_action.finished
	# So enemies don't attack dying summons and special action doesn't repeat 
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
	


func _on_texture_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Data.bestiary.show_menu(
			[stats.name, stats.art, "\nActions\n\n%s" % stats.description, stats.flavour_text], 
			false)


func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(BUBBLE_CURSOR)


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(CURSOR)
