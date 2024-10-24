class_name Enemy
extends Area2D

const ARROW_OFFSET := 19

@export var ai: EnemyAI
@export var stats: EnemyStats : set = _setup_stats
@export var active_cards: Array[EnemyCard]
@export var cards: Array[EnemyCard]

@onready var sprite_2d : Sprite2D = %Sprite2D
@onready var arrow : Sprite2D = %Arrow
@onready var stats_ui : StatsUI = %StatsUI
@onready var mana_counter: RichTextLabel = %ManaCounter
@onready var status_handler: StatusHandler = %StatusHandler
@onready var modifier_handler: ModifierHandler = %ModifierHandler

var pool: Array[EnemyCard]
var mana: int
var active := false
var is_alive := true
var total_card_weight := 0


func _setup_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if !stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_enemy()
	_setup_card_weights()
	
	if !is_node_ready(): await ready
	status_handler.status_owner = self


func _setup_card_weights() -> void:
	total_card_weight = 0 # Not needed but is nice for safety
	for card: EnemyCard in ai.actions:
		total_card_weight += card.weight
		card.cumulative_weight = total_card_weight


func draw_cards(amount: int) -> void:
	# DO NOT REMOVE THIS LINE UNLESS YOU WANT TO SPEND HOURS TRYING TO DEBUG SOMETHING THAT DOESN'T EXIST
	if !active: return
	
	for card in amount:
		var roll := randi_range(0, total_card_weight)
		
		for i in ai.actions.size():
			if ai.actions[i].cumulative_weight >= roll:
				add_card(ai.actions[i])


# Health cards are drawn whenever the enemy takes damage and health is <= the cards health stat
func check_health_cards() -> void:
	for i in ai.health_cards.size(): 
		if stats.health <= ai.health_cards[i].health:
			add_card(ai.health_cards[i])


func add_card(card: EnemyCard) -> void:
	# Prevents old enemies from adding cards right before they're freed
	if !active: return
	
	# Adds a health card
	if card.health && (card.health > stats.health):
		get_parent().add_card_to_hand.emit(card, self)
	
	# Adds a regular card using mana
	elif mana > 0:
		mana -= card.cost
		get_parent().add_card_to_hand.emit(card, self)


func update_stats() -> void:
	stats_ui.update_stats(stats)


func update_enemy() -> void:
	if !stats is Stats:
		return
	
	if !is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	arrow.position = (Vector2.UP * (sprite_2d.get_rect().size.y / 2 + ARROW_OFFSET)) + Vector2(0, 4)
	update_stats()


func do_turn() -> void:
	stats.barrier = clamp((stats.barrier -10), 0, 999)
	status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)


# Doesn't work as setter from mana var (mana decreases before cards are actually drawn)
func update_mana_counter() -> void:
	mana_counter.text = "[center][color=3D7BFF] %s [/color][/center]" % mana


func take_damage(damage : int, modify_damage := true) -> void:
	if stats.health <= 0: return
	GameManager.damage_dealt += damage
	
	var modified_damage := modifier_handler.get_modified_value(damage, Modifier.Type.DMG_TAKEN)
	if !modify_damage: modified_damage = damage
	
	var tween := create_tween()
	tween.tween_callback(get_tree().current_scene.shaker.shake.bind(self, 12, 0.15))
	tween.tween_callback(stats.take_damage.bind(modified_damage))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func()->void:
			check_health_cards()
			if stats.health <= 0:
				death_animation())


func death_animation(repeats := 3) -> void:
	is_alive = false
	var death_tween := create_tween()
	death_tween.tween_callback(get_tree().current_scene.shaker.shake.bind(self, 10, 0.15))
	death_tween.tween_interval(0.2)
	
	death_tween.finished.connect(
		func()->void:
			#Repeats damage anim for more effect
			for i in repeats: death_animation(repeats - 1)
			if !repeats:
				# Await prevents death anim from ending early
				await get_tree().create_timer(0.2, false).timeout
				Events.enemy_died.emit(self)
				queue_free())


func _on_area_entered(_area: Node) -> void:
	if _area.get_parent().get_name() == "CardTargetSelector":
		arrow.show()

func _on_area_exited(_area: Node) -> void:
	arrow.hide()


func _on_mouse_entered() -> void:
	get_parent().show_cards_owned_by_enemy.emit(self)


func _on_mouse_exited() -> void:
	get_parent().hide_enemy_card_arrows.emit()
