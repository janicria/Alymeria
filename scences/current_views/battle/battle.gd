class_name Battle
extends Node2D

enum State {BASE, LOOPS, ENEMY_DRAW, PLAYER, ENEMY_CARDS, WIN, LOSE}

@export var battle_stats: BattleStats
@export var music : AudioStream

@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handeler: PlayerHandeler = $PlayerHandeler
@onready var player: Player = $Player

var core_handler: CoreHandler


func _ready() -> void:
	Events.update_battle_state.connect(_on_update_battle_state)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)


func start_battle() -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	
	player.stats = Data.character
	enemy_handler.setup_enemies(battle_stats)
	player_handeler.start_battle(Data.character)
	battle_ui.initialise_card_pile_ui()
	
	await get_tree().process_frame
	battle_stats.live_enemies.clear()
	for enemy: Enemy in enemy_handler.get_enemies():
		battle_stats.live_enemies.append(enemy) 
	
	Events.update_battle_state.emit(State.BASE)


func _on_update_battle_state(state: State) -> void:
	match state:
		State.BASE:
			Data.turn_number = 0
			core_handler.activate_cores_of_type(Core.Type.START_OF_COMBAT)
			for coreui: CoreUI in core_handler.get_all_coreuis(): coreui.playable = true
			await core_handler.core_activated
			Events.update_battle_state.emit(State.LOOPS)
		
		State.LOOPS:
			Data.save_to_file()
			core_handler.activate_cores_of_type(Core.Type.START_OF_TURN)
			await core_handler.core_activated
			Events.update_turn_number.emit(Data.turn_number + 1)
			enemy_handler.start_mana()
			battle_stats.turn_effects()
			Events.update_battle_state.emit(State.ENEMY_DRAW)
		
		State.ENEMY_DRAW: # Also enemy statuses
			enemy_handler.apply_start_of_turn_statuses()
			#await enemy_handler.statuses_applied
			enemy_handler.draw_cards()
			# First wait in case an enemy draws a card by itself
			# Second is simply to smooth out animations / UX
			await enemy_handler.finished_drawing
			await get_tree().create_timer(0.2).timeout
			Events.update_battle_state.emit(State.PLAYER)
		
		State.PLAYER:
			player_handeler.start_turn()
		
		State.ENEMY_CARDS:
			player_handeler.end_turn()
			await Events.player_hand_discarded
			core_handler.activate_cores_of_type(Core.Type.END_OF_TURN)
			await core_handler.core_activated
			if !enemy_handler.get_enemies().all(func(enemy:Enemy)->bool:
				return enemy.is_alive): return # If all the enemies are dead
			enemy_handler.start_turn()
			await enemy_handler.statuses_applied
			enemy_handler.play_next_card()
		
		State.WIN:
			if !is_inside_tree(): OS.alert("Need return here")
			for coreui: CoreUI in core_handler.get_all_coreuis(): coreui.playable = false
			core_handler.activate_cores_of_type(Core.Type.END_OF_COMBAT)
			print("Victory!")
			Data.save_to_file()
		
		State.LOSE:
			for coreui: CoreUI in core_handler.get_all_coreuis(): coreui.playable = false


func _on_enemy_handler_child_order_changed() -> void:
	# When the game is exiting all enemies are freed causing
	# the game to think that the battle is won and try to save
	if enemy_handler.get_child_count() == 1 && is_inside_tree():
		Events.update_battle_state.emit(State.WIN)
