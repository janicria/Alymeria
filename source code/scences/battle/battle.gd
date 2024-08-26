class_name Battle
extends Node2D

enum BattleState {BASE, LOOPS, EVENTS, PLAYER, ENEMY, WIN, LOSE}

@export var char_stats : CharacterStats
@export var music : AudioStream

@onready var enemy_handler: EnemyHandler = $EnemyHandler
@onready var battle_ui: BattleUI = $BattleUI
@onready var player_handeler: PlayerHandeler = $PlayerHandeler
@onready var player: Player = $Player
@onready var enemy_hand

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
	
	Events.battle_state_updated.connect(_on_battle_state_updated)
	
	#enemy_hand.child_order_changed.connect(_on_enmeies_child_order_changed)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	Events.player_died.connect(_on_player_died)
	
	start_battle(new_stats)
	battle_ui.initialise_card_pile_ui()


func start_battle(stats : CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	#enemy_hand.reset_enemy_actions()
	player_handeler.start_battle(stats)
	Events.battle_state_updated.emit(0)


func _on_enmeies_child_order_changed() -> void:
	#if enemy_hand.get_child_count() == 0:
	#	Events.battle_state_updated.emit(5)
	#	print("Victory! ", self)
	pass


func _on_enemy_turn_ended() -> void:
	player_handeler.start_turn()
	#enemy_hand.reset_enemy_actions()
	Events.battle_state_updated.emit(2)


func _on_player_died() -> void:
	Events.battle_state_updated.emit(6)
	print("You died lol ", self)


func _on_battle_state_updated(new_state : BattleState) -> void:
	state = new_state
	
	if new_state == 1:  # Need to hook up loops state here
		_on_enemy_turn_ended()
	
	if new_state == 2:  # Need to hook up events state here
		Events.battle_state_updated.emit(3)
	
	if new_state == 3:
		Events.enemy_reload_targets.emit(null)
	
	if new_state == 4:
		player_handeler.end_turn()
	
	return
