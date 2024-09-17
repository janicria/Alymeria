class_name Battle
extends Node2D

enum BattleState {BASE, LOOPS, ENEMY_DRAW, PLAYER, ENEMY_CARDS, WIN, LOSE}

@export var battle_stats: BattleStats
@export var music : AudioStream
@export var char_stats: CharacterStats
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
	
	battle_ui.char_stats = char_stats
	player.stats = char_stats
	enemy_handler.setup_enemies(battle_stats)
	player_handeler.start_battle(char_stats)
	battle_ui.initialise_card_pile_ui()
	
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
			print("Victory!")


func _on_enemy_handler_child_order_changed() -> void:
	if enemy_handler.get_child_count() == 1:
		Events.battle_state_updated.emit(5)


func _on_battle_request_player_turn() -> void:
	if state == BattleState.ENEMY_DRAW :
		# Pause so anim looks nicer
		await get_tree().create_timer(0.5).timeout
		Events.battle_state_updated.emit(3)