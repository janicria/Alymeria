class_name EnemyHand extends HBoxContainer

signal cards_finished_moving

const CARD_OFFSET := 76
const ENEMY_CARDUI = preload("res://scences/enemy/enemy_card.tscn")

var card_start_position := func()->Vector2:
	return position - Vector2(80, -5)
var organiser_target_pos: Vector2

func _ready() -> void:
	get_parent().add_card_to_hand.connect(cardToGui)
	get_parent().show_cards_owned_by_enemy.connect(show_cards_owned_by_enemy)
	get_parent().hide_enemy_card_arrows.connect(hide_enemy_card_arrows)


func cardToGui(card: EnemyCard, enemy: Enemy) -> void:
	# Creating card
	var card_ui := ENEMY_CARDUI.instantiate()
	card_ui.hide()
	card_ui.global_position = enemy.mana_counter.global_position - Vector2(160, 60)
	card_ui.update_stats(card, enemy)
	add_child(card_ui) 
	
	# Setting up card for movement
	var target_pos := position - Vector2(80, -5) 
	for i in get_child_count():
		target_pos.x += CARD_OFFSET
		if !card.health: await get_tree().create_timer(0.3).timeout
	card_ui.visible = true
	
	# Moving card
	var tween := create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(card_ui, "global_position", target_pos, 0.6)
	
	# Updating enemy mana and player damage counters
	tween.finished.connect(func()->void:
		card_ui.arrow.global_position = card_ui.global_position + card_ui.arrow.position
		var wr: WeakRef = weakref(enemy)
		if !wr.get_ref(): return
		enemy.update_mana_counter()
		if card.type == EnemyCard.Type.ATTACK:
			Events.update_player_dmg_counter.emit((card_ui.modified_damage if card_ui.modified_damage else card.amount) * card.repeats, false))
	
	# Starting player draw
	if card_ui == get_child(-1):
		get_parent().finished_drawing.emit()


func organise_cards() -> void:
	# Setup
	organiser_target_pos = card_start_position.call()
	
	# Moving card
	for card: EnemyCardUI in get_children():
		organiser_target_pos.x += CARD_OFFSET
		var tween := create_tween().set_trans(Tween.TRANS_BACK)
		tween.tween_property(card, "global_position", organiser_target_pos, 0.5)
		# We want multiple cards to move at the same time
		await get_tree().create_timer(0.1).timeout
		# Scheduling the next card to be played after all cards have been moved
		if card == get_child(-1): 
			cards_finished_moving.emit()
	
	if !get_children(): 
		Events.update_battle_state.emit(Battle.State.LOOPS)


func show_cards_owned_by_enemy(enemy: Enemy) -> void:
	for cardui: EnemyCardUI in get_children():
		if cardui.enemy_stats == enemy: cardui.arrow.show()


func hide_enemy_card_arrows() -> void:
	for cardui: EnemyCardUI in get_children():
		cardui.arrow.hide()
