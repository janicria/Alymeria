class_name EnemyHand
extends HBoxContainer

const ENEMY_CARD_SCENE = preload("res://custom_resources/enemy_card.tscn")

@export var time_before_next_card := 0.0

var organiser_target_pos := position - Vector2(30, -5)


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
	
	# Updating player damage counter
	tween.finished.connect(func()->void: if card.type == EnemyCard.Type.ATTACK:
		Events.update_player_dmg_counter.emit(card.amount, false))
	
	# Starting player draw
	if card_ui == get_child(-1):
		Events.battle_request_player_turn.emit()


# await is for cards which are queued_for_deletion() bc the method doesn't work lol
func organise_cards(draw_next_card := true) -> void:
	# Setup
	await get_tree().create_timer(0.1).timeout
	organiser_target_pos = position - Vector2(30, -5) 
	time_before_next_card = 0
	
	# Moving card
	for card: EnemyCardUI in get_children():
		organiser_target_pos.x += 38
		var tween := create_tween().set_trans(Tween.TRANS_BACK)
		tween.tween_property(card, "global_position", organiser_target_pos, 0.5)
		await get_tree().create_timer(0.1).timeout
		time_before_next_card += 0.1
	
	# Scheduling the next card to be played by enemy_handler
	if draw_next_card: Events.enemy_card_played.emit()
