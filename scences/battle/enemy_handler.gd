class_name EnemyHandler
extends Node2D

@onready var enemy_hand: EnemyHand = $EnemyHand


func _ready() -> void:
	Events.battle_find_enemies.connect(_on_battle_find_enemies)
	Events.enemy_find_enemies.connect(_on_enemy_find_enemies)
	Events.enemy_card_played.connect(play_next_card)


func setup_enemies(battle_stats: BattleStats) -> void:
	if !battle_stats:
		return
	
	# Removes old enemies
	for enemy: Node in get_children():
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
		enemy.draw_cards(enemy.stats.max_turn_draw)


func start_turn() -> void:
	if get_child_count() == 0:
		return
	
	# Filter prevents EnemyHand from being assigned
	for enemy: Enemy in get_children().filter(func(child: Node)->bool: return child is Enemy):
		enemy.do_turn()


func play_next_card() -> void:
	if !enemy_hand.get_children():
		Events.battle_state_updated.emit(1)
		return
	
	await get_tree().create_timer(enemy_hand.time_before_next_card + 0.35).timeout
	
	var card := enemy_hand.get_child(0) as EnemyCardUI
	
	card.play()
	
	# So it doesn't get shadowrealmed from memory right away
	if card.card_stats.repeats != 1: 
		card.visible = false
		# Approx time taken for a card to be played
		await get_tree().create_timer((card.card_stats.repeats-1)*1.5).timeout
	
	enemy_hand.remove_child(card)
	card.queue_free()
	enemy_hand.organise_cards()


func _on_battle_find_enemies() -> void:
	await get_tree().create_timer(0.2, false).timeout
	Events.battle_give_enemies.emit(get_children())


func _on_enemy_find_enemies(original_id : String, damage : int, repeats : int) -> void:
	await get_tree().create_timer(0.2, false).timeout
	Events.enemy_give_enemies.emit(get_children(), original_id, damage, repeats)
