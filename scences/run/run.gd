class_name Run
extends Node

const BATTLE_SCENCE := preload("res://scences/battle/battle.tscn")
const SHOP_SCENCE := preload("res://scences/shop/shop.tscn")
const TREASURE_SCENCE := preload("res://scences/treasure/treasure.tscn")
const BATTLE_REWARD_SCENCE := preload("res://scences/battle_rewards/battle_rewards.tscn")
const HAVEN_SCENCE := preload("res://scences/haven/haven.tscn")
const EVENT_SCENCE := preload("res://scences/events/event.tscn")

@export var run_startup: RunStartup

@onready var map: Map = %Map
@onready var current_view: Node = %CurrentView
@onready var top_bar: TextureRect = %TopBar
@onready var scence_transition: AnimationPlayer = %ScenceTransition
@onready var color_rect: ColorRect = %ColorRect
@onready var console_window: Window = %ConsoleWindow

var character: CharacterStats


func _ready() -> void:
	if !run_startup:
		return
	
	color_rect.visible = true
	#console_window.close_requested.emit()
	scence_transition.play("fade_in")
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			GameSave.character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("Load contuined run")
	
	Events.update_deck_buttons.emit(0, true)


func _start_run() -> void:
	_setup_event_connections()
	Events.update_card_pile.emit(GameSave.character.deck)
	map.generate_new_map()
	map.unlock_floor(0)


func _change_view(scence : PackedScene) -> Node:
	# Failsafe which runs while the game is exiting
	var wr = weakref(get_tree())
	if !wr.get_ref(): return
	
	# Removes the previous view
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scence.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	return new_view


func _show_map() -> void:
	# Prevents multiple views from being open at the same time
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()


func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_on_reward_exited)
	Events.haven_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_show_map)
	Events.events_extied.connect(_show_map)


func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("~_pressed"):
		console_window.visible = !console_window.visible
	elif _event.is_action_pressed("escape"):
		Events.update_settings_visibility.emit()


func _on_battle_room_entered(_room: Room) -> void:
	var battle_scence: Battle = _change_view(BATTLE_SCENCE) as Battle
	battle_scence.char_stats = GameSave.character
	battle_scence.battle_stats = preload("res://floors/battles/a1_tier0_pure_bat2.tres")
	battle_scence.start_battle()


func _on_battle_won() -> void:
	# Failsafe which runs while the game is exiting
	var wr = weakref(get_tree())
	if !wr.get_ref(): return
	
	
	var reward_scence := _change_view(BATTLE_REWARD_SCENCE) as BattleReward
	
	reward_scence.add_gold_reward(72)
	reward_scence.add_card_reward()


func _on_reward_exited() -> void:
	var event_chance := randi_range(0, 4)
	if !event_chance:
		print("rolled event scence %s (1/5)" % event_chance)
		_change_view(EVENT_SCENCE)
	else:
		print("rolled map scence %s (4/5)" % event_chance)
		_show_map()


func _on_map_exited(room: Room) -> void:
	GameSave._log("Floor %s: %s (column/type)" % [map.floors_climbed, room])
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_change_view(TREASURE_SCENCE)
		Room.Type.HAVEN:
			_change_view(HAVEN_SCENCE)
		Room.Type.SHOP:
			_change_view(SHOP_SCENCE)
		Room.Type.ELITE:
			_on_battle_room_entered(room)
		Room.Type.BOSS:
			_on_battle_room_entered(room)
