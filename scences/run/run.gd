class_name Run
extends Node

const BATTLE_SCENCE := preload("res://scences/current_views/battle/battle.tscn")
const SHOP_SCENCE := preload("res://scences/current_views/shop/shop.tscn")
const TREASURE_SCENCE := preload("res://scences/current_views/treasure/treasure.tscn")
const BATTLE_REWARD_SCENCE := preload("res://scences/current_views/battle_rewards/battle_rewards.tscn")
const HAVEN_SCENCE := preload("res://scences/current_views/haven/haven.tscn")
const EVENT_SCENCE := preload("res://scences/current_views/events/event.tscn")

@export var run_startup: RunStartup

@onready var map: Map = %Map
@onready var current_view: Node = %CurrentView
@onready var scence_transition: AnimationPlayer = %ScenceTransition
@onready var color_rect: ColorRect = %ColorRect
@onready var console_window: Window = %ConsoleWindow
@onready var version_number: Label = %VersionNumber
@onready var settings_bar: TextureRect = %SettingsBar

var character: CharacterStats


func _ready() -> void:
	color_rect.visible = true
	scence_transition.play("fade_in")
	version_number.text = ProjectSettings.get_setting("application/config/version")

	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			GameManager.character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("Load contuined run")
	
	Events.update_deck_button_ui.emit()


func _process(_delta: float) -> void:
	# Prevents the map camera from moving screen elements
	version_number.global_position.y = 2 - version_number.get_canvas_transform().origin.y
	settings_bar.global_position.y = 0 - settings_bar.get_canvas_transform().origin.y


func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("~_pressed"): 
		console_window.visible = !console_window.visible


func _start_run() -> void:
	_setup_event_connections()
	Events.update_card_pile.emit(GameManager.character.deck)
	map.generate_new_map()
	map.unlock_floor(0)
	GameManager.reset_stats()


func _change_view(scence : PackedScene) -> Node:
	# Failsafe which runs while the game is exiting
	var wr: WeakRef = weakref(get_tree())
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
	Events.update_battle_state.connect(_on_battle_state_updated)
	Events.battle_reward_exited.connect(_on_reward_exited)
	Events.haven_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_show_map)
	Events.events_extied.connect(_show_map)


func _on_battle_room_entered(room: Room) -> void:
	var battle_scence: Battle = _change_view(BATTLE_SCENCE)
	battle_scence.battle_stats = room.battle_stats # Translation: (8 * biome * InfectedMultipliers)% hopefully
	GameManager.floor_is_infected = !room.battle_stats.pure && ((float((8)*(GameManager.current_biome+1)*GameManager.multipliers["INFECTION"])/100)>randf())
	battle_scence.start_battle()


func _on_battle_state_updated(state: Battle.BattleState) -> void:
	if state != Battle.BattleState.WIN: return
	
	# Failsafe which runs while the game is exiting
	var wr: WeakRef = weakref(get_tree())
	if !wr.get_ref(): return
	
	var reward_scence := _change_view(BATTLE_REWARD_SCENCE) as BattleReward
	reward_scence.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scence.add_card_reward()


func _on_reward_exited() -> void:
	if !randi_range(0, 4):
		print("Rolled event scence (1/5)")
		_change_view(EVENT_SCENCE)
	else:
		print("Rolled map scence (4/5)")
		_show_map()


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER: _on_battle_room_entered(room)
		Room.Type.TREASURE: _change_view(TREASURE_SCENCE)
		Room.Type.HAVEN: _change_view(HAVEN_SCENCE)
		Room.Type.SHOP: _change_view(SHOP_SCENCE)
		Room.Type.ELITE: _on_battle_room_entered(room)
		Room.Type.BOSS: _on_battle_room_entered(room)
	print("Floor %s: %s%s %s (column/type/tier/infected)" % [map.floors_climbed, room, str(map.last_room.battle_stats.battle_tier) if map.last_room.battle_stats else "X", GameManager.floor_is_infected])
