class_name Enemy extends Area2D

const ARROW_OFFSET := 19
const CURSOR = preload("res://assets/misc/cursor.png")
const BUBBLE_CURSOR = preload("res://assets/misc/bubble_cursor.png")

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
	
	sprite_2d.flip_h = stats.flip_sprite
	status_handler.status_owner = self
	for status in stats.starter_statuses:
		status_handler.add_status(status)


func _setup_card_weights() -> void:
	# Gets called whenever stats changes
	total_card_weight = 0
	for card in ai.actions:
		card.cumulative_weight = 0
	
	for card in ai.actions:
		total_card_weight += card.weight
		card.cumulative_weight = total_card_weight


func summon() -> void:
	Data.enemy_handler.add_child(self)
	active = true
	stats.health = ceili(stats.health * 0.5)
	stats.max_mana -= 1
	global_position = Vector2(
		randi_range(400, 600), randi_range(110, 140))


func draw_cards(amount: int) -> void:
	# In case old enemies haven't been cleared yet
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
	elif mana >= card.cost:
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
	stats.barrier = clampi((stats.barrier -10), 0, 999)
	status_handler.apply_statuses_by_type(Status.Type.END_OF_TURN)


# Doesn't work as setter from mana var (mana decreases before cards are actually drawn)
func update_mana_counter() -> void:
	mana_counter.visible = mana
	mana_counter.text = "[center][color=3D7BFF][font_size=6]%s[/font_size][/color][/center]" % mana


func take_damage(damage : int, modify_damage := true) -> void:
	if stats.health <= 0: return
	Data.damage_dealt += damage

	var modified_damage := modifier_handler.get_modified_value(damage, Modifier.Type.DMG_TAKEN)
	if !modify_damage: modified_damage = damage
	var tween := create_tween()
	tween.tween_callback(
		get_tree()
		.current_scene.shaker.shake.bind(self, 12, 0.2))
	
	tween.finished.connect(
		func()->void:
			if stats.take_damage(modified_damage):
				check_health_cards()
			if stats.health <= 0:
				death_animation())


func death_animation(repeats := 3) -> void:
	is_alive = false
	var death_tween := create_tween()
	death_tween.tween_callback(
		get_tree().current_scene.shaker.shake.bind(self, 30, 0.2))
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
	Input.set_custom_mouse_cursor(BUBBLE_CURSOR)


func _on_mouse_exited() -> void:
	get_parent().hide_enemy_card_arrows.emit()
	Input.set_custom_mouse_cursor(CURSOR)


func _on_mouse_hitbox_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		Data.bestiary.show_menu(to_bestiary(), false)


func to_bestiary() -> Array:
	# Cards
	var cards_text := "Cards\n\n" if stats.starter_statuses.is_empty() else "Cards\n"
	for card in ai.actions + ai.health_cards:
		cards_text += "[color=CD57FF]%s[/color] [color=0044ff]%s mana[/color] %s%s [color=CD57FF]%s[/color]\n%s %s\n\n" % [
			to_title(card.resource_path.get_slice("/", 4).trim_suffix(".tres")),
			card.cost,
			("[color=ff0000]" +str(card.health)+ " health[/color]") if card.health else "",
			(str(card.weight) + " weight") if card.weight else "",
			to_title(EnemyCard.Targets.find_key(card.targets)),
			to_title(EnemyCard.Type.find_key(card.type)) if card.type < 5 else card.description, # Trans: 2, if type > energy && repeats: 2x3, else ""
			(((("%sx%s" % [card.amount, card.repeats]) if card.repeats != 1 else card.amount)) if card.type > 4 else card.amount) if card.amount else ""] # Yikes
	# Statuses
	if stats.starter_statuses.is_empty(): 
		return [stats.name, stats.art, cards_text, ""]
	var status_text := "Statuses\n"
	for status in stats.starter_statuses:
		status_text += "[color=%s]%s[/color]" % [
			("1AD12C" if status.buff else "AB3321"), to_title(status.id)]
		if status != stats.starter_statuses[-1]:
			status_text += "  "
	return [stats.name, stats.art, cards_text, status_text]


func to_title(text: String) -> String:
	return (text.to_snake_case().replace("_", " ").substr(0, 1).to_upper()
	+ text.to_snake_case().replace("_", " ").substr(1)) # First letter + the rest
