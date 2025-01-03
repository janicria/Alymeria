class_name Main extends Node

const BATTLE_SCENCE := preload("res://scences/views/battle/battle.tscn")
const SHOP_SCENCE := preload("res://scences/views/shop/shop.tscn")
const TREASURE_SCENCE := preload("res://scences/views/treasure/treasure.tscn")
const HAVEN_SCENCE := preload("res://scences/views/haven/haven.tscn")
const EVENT_SCENCE := preload("res://scences/views/events/event.tscn")
const COMPASS = preload("res://characters/global/cores/common/compass.tres")
const CURSOR = preload("res://assets/misc/cursor.png")

@export var run_startup: RunStartup

@onready var map: Map = %Map
@onready var current_view: Node = %CurrentView
@onready var version_number: Label = %VersionNumber
@onready var settings_bar: TextureRect = %SettingsBar
@onready var core_handler: CoreHandler = %CoreHandler
@onready var bestiary: Bestiary = %Bestiary
@onready var scence_transition: AnimationPlayer = %ScenceTransition
@onready var color_rect: ColorRect = %ColorRect
@onready var console_window: Window = %ConsoleWindow
@onready var shaker: Node = %Shaker

var character: CharacterStats
var fix_node_positions := true

func _ready() -> void:
	color_rect.visible = true
	scence_transition.play("fade_in")
	version_number.text = ProjectSettings.get_setting("application/config/version")
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			Data.character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("Load contuined run")
	
	Events.update_deck_button_ui.emit()


func _process(_delta: float) -> void:
	if fix_node_positions:
		# Prevents the map camera from moving screen elements
		version_number.global_position.y = 4 - version_number.get_canvas_transform().origin.y
		settings_bar.global_position.y = 0 - settings_bar.get_canvas_transform().origin.y
		core_handler.global_position.y = 76 - core_handler.get_canvas_transform().origin.y
		bestiary.global_position.y = 14 - bestiary.get_canvas_transform().origin.y
	
	# In case something which changes the cursor is shadowrealmed
	if Engine.get_frames_drawn() % 600 == 0: # Averages to 5s
		Input.set_custom_mouse_cursor(CURSOR)


func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("~_pressed") && console_window != null: 
		console_window.visible = !console_window.visible


func _start_run() -> void:
	_setup_event_connections()
	Events.update_card_pile.emit(Data.character.deck)
	map.generate_new_map()
	map.unlock_floor(0)
	Data.reset_stats()
	core_handler.add_core(Data.character.starting_core)


func _change_view(scence: PackedScene) -> Node:
	# Failsafe which runs while the game is exiting
	if !is_inside_tree(): return
	
	# Removes the previous view
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	if scence == EVENT_SCENCE: print("Rolled event scene")
	
	get_tree().paused = false
	var new_view := scence.instantiate()
	current_view.add_child(new_view)
	map.hide_map()
	Data.save_to_file()
	
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
	map.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_show_map)
	Events.treasure_room_exited.connect(_show_map)
	Events.events_extied.connect(event_exited)


func event_exited() -> void:
	if core_handler.get_core("Compass") == null:
		_show_map()
		return
	elif core_handler.get_core("Compass").coreui.slotted:
		_on_reward_exited()
	else: _show_map()


func _on_battle_room_entered(room: Room) -> void:
	var battle_scence: Battle = _change_view(BATTLE_SCENCE)
	battle_scence.battle_stats = room.battle_stats # Translation: (8 * biome * InfectedMultipliers)% hopefully
	Data.floor_is_infected = !room.battle_stats.pure && (
		(float((8)*(Data.current_biome+1)*Data.multipliers["INFECTION"])/100)>randf())
	battle_scence.core_handler = core_handler
	battle_scence.start_battle()


func _on_battle_state_updated(state: Battle.State) -> void:
	# Room check is if battle was set through console
	if state != Battle.State.WIN || !map.last_room: 
		return
	
	if map.last_room.battle_stats.battle_tier == BattleStats.BattleTier.BOSS:
		Data.battle.credits.begin()
	
	else:
		var reward_scence: Treasure = _change_view(TREASURE_SCENCE)
		reward_scence.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
		reward_scence.add_card_reward(0)
		if map.last_room.battle_stats.battle_tier == BattleStats.BattleTier.ELITE:
			reward_scence.add_core_reward(2, 0)


func _on_reward_exited() -> void:
	#TODO: Do next version pls
	#var event_range := 20
	#if core_handler.get_core("Compass"):
	#	event_range = 40 if core_handler.get_core("Compass").coreui.slotted else 30
	#
	#if randi_range(0, 100) <= event_range: 
	#	_change_view(EVENT_SCENCE)
	#	print("Event -> %d%%" % event_range)
	#else: _show_map()
	_show_map()


func enter_treasure_room() -> void:
	var treasure_scene: Treasure = _change_view(TREASURE_SCENCE)
	# First reward
	match randi_range(0, 2):
		0: treasure_scene.add_gold_reward(randi_range(40, 80))
		1: 
			treasure_scene.add_gold_reward(randi_range(30, 40))
			treasure_scene.add_core_reward(2, 0, Core.Rarity.COMMON, "Add a common core")
		2: treasure_scene.add_core_reward(2, 0)
	# Second reward
	match randi_range(0, 2):
		0: treasure_scene.add_core_reward(2, randi_range(20, 40))
		1: treasure_scene.add_card_reward(
			randi_range(20, 40), Card.Rarity.RARE, "Add a rare card")
		2: treasure_scene.add_core_reward(
			2, randi_range(40, 60), Core.Rarity.RARE, "Add a rare core")


func _on_map_exited(room: Room) -> void:
	match room.type:
		Room.Type.MONSTER: _on_battle_room_entered(room)
		Room.Type.TREASURE: enter_treasure_room()
		Room.Type.HAVEN: _change_view(HAVEN_SCENCE)
		Room.Type.SHOP: _change_view(SHOP_SCENCE)
		Room.Type.ELITE: _on_battle_room_entered(room)
		Room.Type.BOSS: _on_battle_room_entered(room)
	print("Floor %s: %s%s %s (column/type/tier/infected)" % [
		map.floors_climbed,
		room, str(map.last_room.battle_stats.battle_tier) if map.last_room.battle_stats else "X", 
		Data.floor_is_infected])
