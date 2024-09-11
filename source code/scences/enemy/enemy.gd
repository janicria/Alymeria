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
@onready var box: TextureRect = $Box

var hand: Array[EnemyCard]
var total_card_weight: int
var pool: Array[EnemyCard]
var mana: int


func _setup_stats(value: EnemyStats) -> void:
	stats = value.create_instance()
	
	if !stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	mana = stats.max_mana
	update_enemy()


func draw_cards(amount: int) -> void:
	for i in amount:
		var continue_rolling := true
		update_weights()
		
		while continue_rolling:
			var roll := randi_range(0, total_card_weight)
			var rolled_cards: Array[EnemyCard] # HACK: No loop?
			if ai.action_1 and ai.action_1.weight and ai.action_1.weight > roll-1: rolled_cards.append(ai.action_1); continue_rolling = false
			if ai.action_2 and ai.action_2.weight and ai.action_2.weight > roll-1: rolled_cards.append(ai.action_2); continue_rolling = false
			if ai.action_3 and ai.action_3.weight and ai.action_3.weight > roll-1: rolled_cards.append(ai.action_3); continue_rolling = false
			if ai.action_4 and ai.action_4.weight and ai.action_4.weight > roll-1: rolled_cards.append(ai.action_4); continue_rolling = false
			if ai.action_5 and ai.action_5.weight and ai.action_5.weight > roll-1: rolled_cards.append(ai.action_5); continue_rolling = false
			if ai.action_6 and ai.action_6.weight and ai.action_6.weight > roll-1: rolled_cards.append(ai.action_6); continue_rolling = false
			if ai.action_7 and ai.action_7.weight and ai.action_7.weight > roll-1: rolled_cards.append(ai.action_7); continue_rolling = false
			if ai.action_8 and ai.action_8.weight and ai.action_8.weight > roll-1: rolled_cards.append(ai.action_8); continue_rolling = false
			if ai.action_9 and ai.action_9.weight and ai.action_9.weight > roll-1: rolled_cards.append(ai.action_9); continue_rolling = false
			if ai.action_10 and ai.action_10.weight and ai.action_10.weight>roll-1:rolled_cards.append(ai.action_10); continue_rolling= false
			if rolled_cards: add_card(rolled_cards.pick_random())  # HACK: Weight systems are hard

func update_weights() -> void: # HACK: No loop 2: Electric boogaloo (TIL this from a movie)
	if ai.action_1: total_card_weight += ai.action_1.weight
	if ai.action_2: total_card_weight += ai.action_2.weight
	if ai.action_3: total_card_weight += ai.action_3.weight
	if ai.action_4: total_card_weight += ai.action_4.weight
	if ai.action_5: total_card_weight += ai.action_5.weight
	if ai.action_6: total_card_weight += ai.action_6.weight
	if ai.action_7: total_card_weight += ai.action_7.weight
	if ai.action_8: total_card_weight += ai.action_8.weight
	if ai.action_9: total_card_weight += ai.action_9.weight
	if ai.action_10:total_card_weight += ai.action_10.weight


func check_health_cards() -> void: # HACK: Yikes 3: The bad one that everyone likes for some reason
	if ai.action_1 and ai.action_1.health and stats.health <= ai.action_1.health: add_card(ai.action_1)
	if ai.action_2 and ai.action_2.health and stats.health <= ai.action_2.health: add_card(ai.action_2)
	if ai.action_3 and ai.action_3.health and stats.health <= ai.action_3.health: add_card(ai.action_3)
	if ai.action_4 and ai.action_4.health and stats.health <= ai.action_4.health: add_card(ai.action_4)
	if ai.action_5 and ai.action_5.health and stats.health <= ai.action_5.health: add_card(ai.action_5)
	if ai.action_6 and ai.action_6.health and stats.health <= ai.action_6.health: add_card(ai.action_6)
	if ai.action_7 and ai.action_7.health and stats.health <= ai.action_7.health: add_card(ai.action_7)
	if ai.action_8 and ai.action_8.health and stats.health <= ai.action_8.health: add_card(ai.action_8)
	if ai.action_9 and ai.action_9.health and stats.health <= ai.action_9.health: add_card(ai.action_9)
	if ai.action_10 and ai.action_10.health and stats.health<=ai.action_10.health:add_card(ai.action_10)


func add_card(card: EnemyCard) -> void: #FIXME
	if !card.cost and !card.weight and card.health > stats.health:
		hand.append(card)
		get_parent().get_child(0).cardToGui(card, self)
	elif !card.cost and card.weight and hand.size() < stats.max_turn_draw:
		print("%s added card %s via card weight" % [stats.id, card.type])
		hand.append(card)
		get_parent().get_child(0).cardToGui(card, self)
	elif mana:
		mana -= card.cost
		hand.append(card)
		get_parent().get_child(0).cardToGui(card, self)


func _ready() -> void:
	draw_cards(stats.max_turn_draw)


func update_stats() -> void:
	stats_ui.update_stats(stats)


func update_enemy() -> void:
	if !stats is Stats:
		return
	
	if !is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	arrow.position = Vector2.UP * (sprite_2d.get_rect().size.y / 2 + ARROW_OFFSET)
	update_stats()


func do_turn() -> void:
	stats.barrier -= 10
	if stats.barrier < 0:
		stats.barrier = 0
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


func update_box() -> void:
	box.position = sprite_2d.position - (sprite_2d.texture.get_size() / 2) - Vector2(2, 2)
	box.size = sprite_2d.texture.get_size() * 1.25
	box.visible = !box.visible


func _on_area_entered(_area: Node) -> void:
	if _area.get_parent().get_name() == "CardTargetSelector":
		arrow.show()


func _on_area_exited(_area: Node) -> void:
	arrow.hide()
