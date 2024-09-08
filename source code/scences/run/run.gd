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
# Debug
@onready var console_window: Window = %ConsoleWindow
@onready var debug_menu: Control = %DebugMenu
@onready var debug_stats: Label = %DebugStats
@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var haven_button: Button = %HavenButton
@onready var event_button: Button = %EventButton


var character: CharacterStats


func _ready() -> void:
	if !run_startup:
		return
	
	
	color_rect.visible = true
	debug_menu.visible = false
	console_window.visible = false
	scence_transition.play("fade_in")
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("Load contuined run")
	
	Events.update_deck_buttons.emit(0, true)


func _start_run() -> void:
	_setup_event_connections()
	Events.update_card_pile.emit(character.deck)
	map.generate_new_map()
	map.unlock_floor(0)


func _change_view(scence : PackedScene) -> Node:
	# Failsafe which runs while the game is exiting
	var wr = weakref(get_tree())
	if !wr.get_ref(): return
	
	
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scence.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	
	if current_view.get_child(0).get_name() == "Battle":
		pass
	
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
	
	# Debug
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENCE))
	haven_button.pressed.connect(_change_view.bind(HAVEN_SCENCE))
	event_button.pressed.connect(_change_view.bind(EVENT_SCENCE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENCE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENCE))
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENCE))
	map_button.pressed.connect(_show_map)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("~_pressed"):
		if debug_menu.visible:
			debug_menu.visible = false
			console_window.visible = false
		else:
			debug_menu.visible = true
			console_window.visible = true


func _process(delta: float) -> void:
	if !debug_menu.visible:
		return
	
	debug_stats.text = "version: " + ProjectSettings.get_setting("application/config/version") + "
character: %s" % run_startup.picked_character.id + "
difficulty: %s " % str(run_startup.difficulty)


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
	
	# TODO: Only call in else block above (rolled map scence)
	_show_map()


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_change_view(BATTLE_SCENCE)
		Room.Type.TREASURE:
			_change_view(TREASURE_SCENCE)
		Room.Type.HAVEN:
			_change_view(HAVEN_SCENCE)
		Room.Type.SHOP:
			_change_view(SHOP_SCENCE)
		Room.Type.ELITE:
			_change_view(BATTLE_SCENCE)
		Room.Type.BOSS:
			_change_view(BATTLE_SCENCE)
