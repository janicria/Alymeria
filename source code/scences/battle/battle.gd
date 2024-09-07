class_name Battle
extends Node2D

enum BattleState {BASE, LOOPS, ENEMY_DRAW, PLAYER, ENEMY_CARDS, WIN, LOSE}

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
	Events.battle_request_player_turn.connect(_on_battle_request_player_turn)
	
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	
	start_battle(new_stats)
	battle_ui.initialise_card_pile_ui()


func start_battle(stats : CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	player_handeler.start_battle(stats)
	Events.battle_state_updated.emit(0)


func _on_player_died() -> void:
	Events.battle_state_updated.emit(6)
	print("You died lol")


func _on_battle_state_updated(new_state : BattleState) -> void:
	state = new_state
	match state:
		0: # Base
			Events.battle_state_updated.emit(1)
		
		1: # Loops
			Events.battle_state_updated.emit(2)
		
		2: # Enemy drawing cards
			enemy_handler.draw_cards()
		
		3: # Player drawing & playing cards
			player_handeler.start_turn()
			enemy_handler.start_turn()
		
		4: # Enemy playing cards
			player_handeler.end_turn()
			await Events.player_hand_discarded
			enemy_handler.play_next_card()
		
		5: # Victory
			Events.battle_won.emit() 
			print("Victory! ", self)


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 1:
		Events.battle_state_updated.emit(5)


func _on_battle_request_player_turn() -> void:
	if state == BattleState.ENEMY_DRAW :
		# Pause so anim looks nicer
		await get_tree().create_timer(0.5).timeout
		Events.battle_state_updated.emit(3)
