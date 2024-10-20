class_name Battle
extends Node2D

enum BattleState {BASE, LOOPS, ENEMY_DRAW, PLAYER, ENEMY_CARDS, WIN, LOSE}

@export var battle_stats: BattleStats
@export var music : AudioStream
@export var state : BattleState

@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handeler: PlayerHandeler = $PlayerHandeler
@onready var player: Player = $Player


func _ready() -> void:
	Events.update_battle_state.connect(_on_update_battle_state)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)


func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	
	player.stats = GameManager.character
	enemy_handler.setup_enemies(battle_stats)
	player_handeler.start_battle(GameManager.character)
	battle_ui.initialise_card_pile_ui()
	
	await get_tree().process_frame # Godot doesn't detect filters when checking array types
	battle_stats.live_enemies.clear()
	for enemy: Enemy in enemy_handler.get_children().filter(func(child:Node)->bool: return child is Enemy):
		battle_stats.live_enemies.append(enemy) 
	
	Events.update_battle_state.emit(0)


func _on_update_battle_state(new_state : BattleState) -> void:
	state = new_state
	match state:
		BattleState.BASE:
			GameManager.turn_number = 0
			Events.update_battle_state.emit(1)
		
		BattleState.LOOPS:
			GameManager.save_to_file()
			Events.update_turn_number.emit(GameManager.turn_number + 1)
			enemy_handler.start_mana()
			battle_stats.turn_effects()
			Events.update_battle_state.emit(2)
		
		BattleState.ENEMY_DRAW: # Also enemy statuses
			enemy_handler.apply_start_of_turn_statuses()
			#await enemy_handler.statuses_applied
			enemy_handler.draw_cards()
			# First wait in case an enemy draws a card by itself
			# Second is simply to smooth out animations / UX
			await enemy_handler.finished_drawing
			await get_tree().create_timer(0.2).timeout
			Events.update_battle_state.emit(3)
		
		BattleState.PLAYER:
			player_handeler.start_turn()
		
		BattleState.ENEMY_CARDS:
			player_handeler.end_turn()
			await Events.player_hand_discarded
			enemy_handler.start_turn()
			await enemy_handler.statuses_applied
			enemy_handler.play_next_card()
		
		BattleState.WIN:
			# When the game is exiting all enemies are freed causing
			# the game to think that the battle is won and try to save
			var wr: WeakRef = weakref(get_tree())
			if !wr.get_ref(): return 
			
			print("Victory!")
			GameManager.save_to_file()


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 1:
		Events.update_battle_state.emit(5)
