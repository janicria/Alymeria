class_name Enemy
extends Area2D


const ARROW_OFFSET := 19

@export var ai: EnemyAI
@export var stats: EnemyStats : set = _setup_stats
@export var active_cards: Array[EnemyCard]
@export var cards: Array[EnemyCard]

@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var arrow : Sprite2D = $Arrow
@onready var stats_ui : StatsUI = $StatsUI

var pool: Array[EnemyCard]
var mana: int
var active := false

func _setup_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if !stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	mana = stats.max_mana
	update_enemy()


func draw_cards(amount: int) -> void:
	for card in amount:
		# Setting up the weights
		var total_card_weight := 0
		var cumulative_weight := 0
		for i in ai.actions.size(): 
			total_card_weight += ai.actions[i].weight
		var roll := randi_range(0, total_card_weight)
		
		# Rolling the cards
		for i in ai.actions.size():
			cumulative_weight += ai.actions[i].weight
			# Health check is prevent health cards from being added as they have 0 weight
			if roll < cumulative_weight && !ai.actions[i].health: add_card(ai.actions[i])


func check_health_cards() -> void:
	for i in ai.actions.size(): 
		if ai.actions[i].health and stats.health <= ai.actions[i].health:
			add_card(ai.actions[i])


func add_card(card: EnemyCard) -> void:
	# Prevents old enemies from adding cards right before they're freed
	if !active: return
	
	# Adds a new card using damage taken
	if !card.cost and !card.weight and card.health > stats.health:
		get_parent().add_card_to_hand.emit(card, self)
	
	# Adds a new card using mana
	elif mana:
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
	arrow.position = (Vector2.UP * (sprite_2d.get_rect().size.y / 2 + ARROW_OFFSET)) + Vector2(0, 8)
	update_stats()


func do_turn() -> void:
	stats.barrier = clamp(stats.barrier -10, 0, 999)
	mana = stats.max_mana


func take_damage(damage : int) -> void:
	if stats.health <= 0:
		return
	
	var tween := create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 12, 0.15))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func()->void:
			check_health_cards()
			if stats.health <= 0:
				death_animation(3)
	)

func death_animation(repeats : int) -> void:
	var death_tween := create_tween()
	death_tween.tween_callback(Shaker.shake.bind(self, 10, 0.15))
	death_tween.tween_interval(0.2)
	
	death_tween.finished.connect(
		func()->void:
			for i in repeats: #Repeats damage anim for more effect
				death_animation(repeats - 1)
			if !repeats:
				# await stops enemy death anim from ending early
				await get_tree().create_timer(0.2, false).timeout
				Events.enemy_died.emit(self)
				queue_free()
	)


func _on_area_entered(_area: Node) -> void:
	if _area.get_parent().get_name() == "CardTargetSelector":
		arrow.show()


func _on_area_exited(_area: Node) -> void:
	arrow.hide()
