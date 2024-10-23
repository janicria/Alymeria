class_name EnemyHand
extends HBoxContainer

signal enemy_card_played

const ENEMY_CARD_SCENE = preload("res://scences/enemy/enemy_card.tscn")

var organiser_target_pos := position - Vector2(30, -5)
# I honestly have no idea why this is needed but it stops enemy cards from ramping up in speed over time
var time_before_next_card := 0.0


func _ready() -> void:
	get_parent().add_card_to_hand.connect(cardToGui)
	get_parent().show_cards_owned_by_enemy.connect(show_cards_owned_by_enemy)
	get_parent().hide_enemy_card_arrows.connect(hide_enemy_card_arrows)


func cardToGui(card: EnemyCard, enemy: Enemy) -> void:
	# Creating card
	var card_ui := ENEMY_CARD_SCENE.instantiate()
	card_ui.position = enemy.position - Vector2(100, 40)
	card_ui.update_stats(card, enemy)
	add_child(card_ui) 
	
	# Setting up card for movement
	var target_pos := position - Vector2(30, -5) 
	for i in get_child_count():
		target_pos.x += 38
		if !card.health: await get_tree().create_timer(0.3).timeout
	card_ui.visible = true
	
	# Moving card
	var tween := create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(card_ui, "global_position", target_pos, 0.6)
	
	# Updating enemy mana and player damage counters
	tween.finished.connect(func()->void:
		card_ui.arrow.global_position = card_ui.global_position + card_ui.arrow.position
		# TODO: Add await for enemy statuses to apply before playing enemy cards
		var wr: WeakRef = weakref(enemy)
		if !wr.get_ref(): return
		enemy.update_mana_counter()
		if card.type == EnemyCard.Type.ATTACK:
			Events.update_player_dmg_counter.emit((card_ui.modified_damage if card_ui.modified_damage else card.amount) * card.repeats, false))
	
	# Starting player draw
	if card_ui == get_child(-1):
		get_parent().finished_drawing.emit()


func organise_cards(draw_next_card := true) -> void:
	# Setup
	organiser_target_pos = position - Vector2(30, -5) 
	time_before_next_card = 0
	
	# Moving card
	for card: EnemyCardUI in get_children():
		organiser_target_pos.x += 38
		var tween := create_tween().set_trans(Tween.TRANS_BACK)
		tween.tween_property(card, "global_position", organiser_target_pos, 0.5)
		await get_tree().create_timer(0.1).timeout
		time_before_next_card += 0.15
	
	# Scheduling the next card to be played by enemy_handler
	if draw_next_card: enemy_card_played.emit()


func show_cards_owned_by_enemy(enemy: Enemy) -> void:
	for cardui: EnemyCardUI in get_children():
		if cardui.enemy_stats == enemy: cardui.arrow.show()


func hide_enemy_card_arrows() -> void:
	for cardui: EnemyCardUI in get_children():
		cardui.arrow.hide()
