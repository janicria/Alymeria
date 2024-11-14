class_name EnemyHandler extends Node2D

signal add_card_to_hand(card: EnemyCard, sender: Node2D)
signal finished_drawing()
signal show_cards_owned_by_enemy(enemy: Enemy)
signal hide_enemy_card_arrows()
signal statuses_applied

@onready var enemy_hand: EnemyHand = %EnemyHand


func _ready() -> void:
	Data.enemy_handler = self
	enemy_hand.cards_finished_moving.connect(play_next_card.bind(false))


func setup_enemies(battle_stats: BattleStats) -> void:
	if !battle_stats:
		return
	
	# Removes old enemies
	for enemy in get_children():
		if enemy is Enemy: enemy.queue_free()
	
	var new_enemies := battle_stats.enemies.instantiate()
	
	for enemy: Node2D in new_enemies.get_children():
		var enemy_child := enemy.duplicate() as Enemy
		enemy_child.active = true
		add_child(enemy_child)
	
	new_enemies.queue_free()


func get_enemies() -> Array[Node]:
	return get_children().filter(func(child:Node)->bool:
		return child is Enemy)


func draw_cards() -> void:
	Events.update_player_dmg_counter.emit(0, true)
	for enemy: Enemy in get_enemies():
		# TODO: Runs twice
		enemy.draw_cards(randi_range(1, 3))


func start_mana() -> void:
	for enemy: Enemy in get_enemies():
		enemy.mana += enemy.stats.max_mana
		enemy.update_mana_counter()


func apply_start_of_turn_statuses() -> void:
	for enemy: Enemy in get_enemies():
		enemy.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
		if (enemy.get_index() != get_child_count() - 2) && enemy.status_handler.has_any_statuses(): 
			await get_tree().create_timer(0.2).timeout
	stauses_finished()


func start_turn() -> void:
	for enemy: Enemy in get_enemies():
		enemy.do_turn()
		if (enemy.get_index() != get_child_count() - 2) && enemy.status_handler.has_any_statuses(): 
			await get_tree().create_timer(0.4).timeout
	stauses_finished()


func play_next_card(first_card := true) -> void:
	# Makes animation look nicer
	await get_tree().create_timer(0.1).timeout
	if !enemy_hand.get_children(): return
	var card := enemy_hand.get_child(0) as EnemyCardUI
	
	if card == null:
		enemy_hand.organise_cards()
		return
	
	card.play()
	
	await card.finished_playing
	if !Data.speedy_cards && !first_card: # Somehow actually works (I think)
		await get_tree().create_timer((enemy_hand.get_child_count()+1)*0.1).timeout
	
	if card != null:
		enemy_hand.remove_child(card)
		card.queue_free()
	enemy_hand.organise_cards()


func stauses_finished() -> void:
	await get_tree().process_frame
	statuses_applied.emit()
