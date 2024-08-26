class_name EnemyHandler
extends Node2D

@onready var enemy_hand: EnemyHand = $EnemyHand


func _ready() -> void:
	Events.enemy_action_completed.connect(_on_enemy_action_completed)
	Events.battle_find_enemies.connect(_on_battle_find_enemies)
	Events.enemy_find_enemies.connect(_on_enemy_find_enemies)
	Events.enemy_card_played.connect(play_next_card)


func reset_enemy_actions() -> void:
	var enemy : Enemy
	for child in get_children():
		enemy = child
		enemy.current_action = null
		enemy.update_action()


func draw_cards() -> void:
	# Filter prevents EnemyHand from being assigned
	for enemy: Enemy in get_children().filter(func(child: Node)->bool: return child is Enemy):
		enemy.draw_cards(enemy.stats.max_turn_draw)


func start_turn() -> void:
	if get_child_count() == 0:
		return
	
	# Filter prevents EnemyHand from being assigned
	for enemy: Enemy in get_children().filter(func(child: Node)->bool: return child is Enemy):
		enemy.do_turn()
	
	play_next_card()


func play_next_card() -> void:
	if !enemy_hand.get_children():
		Events.enemy_turn_ended.emit()
		return
	
	await get_tree().create_timer(enemy_hand.time_before_next_card + 0.35).timeout
	
	var card := enemy_hand.get_child(0) as EnemyCardUI
	
	card.play()
	
	if card.card_stats.repeats != 1: # So it doesn't get shadowrealmed from memory right away
		card.visible = false
		await get_tree().create_timer((card.card_stats.repeats-1)*1.5).timeout
	
	enemy_hand.remove_child(card)
	card.queue_free()
	enemy_hand.organise_cards()


func _on_enemy_action_completed(enemy : Enemy) -> void:
	if enemy.get_index() == get_child_count() -1:
		if get_parent().state != 6:
			Events.battle_state_updated.emit(1)


func _on_battle_find_enemies() -> void:
	await get_tree().create_timer(0.2, false).timeout
	Events.battle_give_enemies.emit(get_children())


func _on_enemy_find_enemies(original_id : String, damage : int, repeats : int) -> void:
	await get_tree().create_timer(0.2, false).timeout
	Events.enemy_give_enemies.emit(get_children(), original_id, damage, repeats)
