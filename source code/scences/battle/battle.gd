class_name Battle
extends Node2D

enum BattleState {BASE, LOOPS, EVENTS, ENEMY, PLAYER, WIN, LOSE}

@export var char_stats : CharacterStats
@export var music : AudioStream

@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handeler: PlayerHandeler = $PlayerHandeler
@onready var player: Player = $Player

@export var state : BattleState

func _ready() -> void:
	# Normally, we would do this on a 'run'
	# level so we keep our health, gold and deck
	# between battles
	# So change this code to only run at the start
	# of a new run later down the line
	# instead of running everytime the game starts
	# As otherwise we can't have multiple floors
	# or even multiple runs
	
	
	var new_stats : CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	GameSave.character = new_stats
	
	Events.player_died.connect(_on_player_died)
	Events.battle_state_updated.connect(_on_battle_state_updated)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	
	start_battle(new_stats)
	battle_ui.initialise_card_pile_ui()


func start_battle(stats : CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	#enemy_hand.reset_enemy_actions()
	player_handeler.start_battle(stats)
	Events.battle_state_updated.emit(0)


func _on_enemy_turn_ended() -> void:
	if state == 5 or state == 6:
		return
	
	player_handeler.start_turn()
	enemy_handler.draw_cards()


func _on_player_died() -> void:
	Events.battle_state_updated.emit(6)
	print("You died lol")


func _on_battle_state_updated(new_state : BattleState) -> void:
	state = new_state
	# FIXME: Replace with switch 
	if new_state == 1:  # Loops turn
		pass
	
	if new_state == 2:  # Events turn
		Events.battle_state_updated.emit(3)
	
	if new_state == 3: # Enemy turn
		enemy_handler.start_turn()
	
	if new_state == 4: # Player turn
		player_handeler.end_turn()
	
	if new_state == 5: # Victory
		Events.battle_won.emit()
	return


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 1:
		Events.battle_state_updated.emit(5)
		Events.battle_won.emit()
		print("Victory! ", self)
