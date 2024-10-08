class_name EnemyHandler
extends Node2D

@onready var enemy_hand: EnemyHand = $EnemyHand

signal add_card_to_hand(card: EnemyCard, sender: Node2D)
signal finished_drawing()
signal show_cards_owned_by_enemy(enemy: Enemy)
signal hide_enemy_card_arrows()
signal statuses_applied

func _ready() -> void: 
	Events.enemy_card_played.connect(play_next_card)
	Events.update_battle_stats.connect(update_enemies)


func update_enemies() -> void:
	if GameManager.combat_is_evenodd == true:
		get_child(1).stats.health = 999
		get_child(2).stats.health = 666



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


func draw_cards() -> void:
	Events.update_player_dmg_counter.emit(0, true)
	# Filter prevents EnemyHand from being assigned
	for enemy: Enemy in get_children().filter(func(child: Node)->bool: return child is Enemy):
		enemy.mana += enemy.stats.max_mana
		enemy.update_mana_counter()
		enemy.draw_cards(randi_range(1, 3))


func apply_start_of_turn_statuses() -> void:
	# Filter prevents EnemyHand from being assigned
	for enemy: Enemy in get_children().filter(func(child: Node)->bool: return child is Enemy):
		enemy.status_handler.apply_statuses_by_type(Status.Type.START_OF_TURN)
		if (enemy.get_index() != get_child_count() - 2) && enemy.status_handler.has_any_statuses(): 
			await get_tree().create_timer(0.2).timeout
	stauses_finished()


func start_turn() -> void:
	#if get_child_count() == 0: return
	# Filter prevents EnemyHand from being assigned
	for enemy: Enemy in get_children().filter(func(child:Node)->bool: return child is Enemy):
		enemy.do_turn()
		if (enemy.get_index() != get_child_count() - 2) && enemy.status_handler.has_any_statuses(): 
			await get_tree().create_timer(0.4).timeout
	stauses_finished()


func stauses_finished() -> void:
	await get_tree().process_frame
	statuses_applied.emit()


func play_next_card() -> void:
	if !enemy_hand.get_children():
		Events.battle_state_updated.emit(1)
		return
	
	await get_tree().create_timer(enemy_hand.time_before_next_card + 0.25).timeout
	
	var card := enemy_hand.get_child(0) as EnemyCardUI
	
	card.play()
	
	# So it doesn't get shadowrealmed from memory right away
	if card.card_stats.repeats != 1: 
		card.visible = false
		# Approx time taken for a card to be played
		await get_tree().create_timer(card.card_stats.repeats-1).timeout
	
	enemy_hand.remove_child(card)
	card.queue_free()
	enemy_hand.organise_cards()
