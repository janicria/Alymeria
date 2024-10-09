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
	Events.player_died.connect(_on_player_died)
	Events.battle_state_updated.connect(_on_battle_state_updated)
	Events.battle_request_player_turn.connect(_on_battle_request_player_turn)
	
	Events.player_hand_discarded.connect(enemy_handler.start_turn)


func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	
	player.stats = GameManager.character
	enemy_handler.setup_enemies(battle_stats)
	player_handeler.start_battle(GameManager.character)
	battle_ui.initialise_card_pile_ui()
	
	Events.battle_state_updated.emit(0)


func _on_player_died() -> void:
	Events.battle_state_updated.emit(6)
	print("You died lol")


func _on_battle_state_updated(new_state : BattleState) -> void:
	state = new_state
	match state:
		0: # Base
			GameManager.turn_number = 0
			Events.battle_state_updated.emit(1)
		
		1: # Loops
			Events.update_turn_number.emit(GameManager.turn_number + 1)
			Events.battle_state_updated.emit(2)
		
		2: # Enemy drawing & applying statuses cards
			enemy_handler.apply_start_of_turn_statuses()
			#await enemy_handler.statuses_applied
			enemy_handler.draw_cards()
			# First wait in case an enemy draws a card by itself
			# Second is simply to smooth out animations / UX
			await enemy_handler.finished_drawing
			await get_tree().create_timer(0.2).timeout
			Events.battle_state_updated.emit(3)
		
		3: # Player drawing & playing cards
			player_handeler.start_turn()
		
		4: # Enemy starting turn then playing cards
			player_handeler.end_turn()
			await Events.player_hand_discarded
			enemy_handler.start_turn()
			await enemy_handler.statuses_applied
			enemy_handler.play_next_card()
		
		5: # Victory
			Events.battle_won.emit() 
			print("Victory!")
			# When the game is exiting all enemies are freed causing 
			# it to think the battle is won and try to save the game
			var wr: WeakRef = weakref(get_tree())
			if wr.get_ref(): GameManager.save_to_file()
		
		6: # Defeat
			pass


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 1:
		Events.battle_state_updated.emit(5)


func _on_battle_request_player_turn() -> void:
	if state == BattleState.ENEMY_DRAW :
		# Pause so anim looks nicer
		await get_tree().create_timer(0.5).timeout
		Events.battle_state_updated.emit(3)
