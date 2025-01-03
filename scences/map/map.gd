class_name Map extends Node2D

signal map_exited(current_room: Room)

const SCROLL_SPEED := 15
const VISUAL_OFFSET := 80
const MAP_ROOM := preload("res://scences/map/map_room.tscn")
const MAP_LINE := preload("res://scences/map/map_line.tscn")

@onready var visuals: Node2D = %Visuals
@onready var lines: Node2D = %Lines
@onready var rooms: Node2D = %Rooms
@onready var camera_2d: Camera2D = %Camera2D
@onready var map_generator: MapGenerator = %MapGenerator
@onready var map_background: CanvasLayer = %MapBackground

var map_data: Array[Array]
var floors_climbed: int
var last_room: Room
var camera_edge_y: float


func _ready() -> void:
	Data.map = self
	camera_edge_y = MapGenerator.Y_DIST * (Data.biome_floors[Data.current_biome] - 2)
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)


func _unhandled_input(event: InputEvent) -> void:
	# Prevents scrolling up whilst viewing a separate scene
	if !visible or Data.card_pile_open: return
	
	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED
	
	# Prevents scrolling infinitely
	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)


func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map()
	create_map()


func create_map() -> void:
	for current_floor: Array in map_data:
		for room: Room in current_floor:
			# Check if room is scheduled to be generated
			if room.next_rooms.size() > 0:
				_spawn_room(room)
	
	# Boss rooms don't have next rooms but still need to be spawned
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_room(map_data[map_generator.floors-1][middle])
	
	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH -1)
	# +80 is so floor 1 isn't too high up
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels + VISUAL_OFFSET) / 2
	visuals.position.y = (get_viewport_rect().size.y + 80) / 2
	# Centres the background elements
	map_background.offset = map_background.get_child(0).position * -1
	

func unlock_floor(which_floor: int = floors_climbed) -> void:
	for map_room: MapRoom in rooms.get_children():
		# Checks if the room is in the right row
		if map_room.room.row == which_floor:
			map_room.available = true


# Called by Main
func unlock_next_rooms() -> void:
	for map_room: MapRoom in rooms.get_children():
		if last_room == null: return # If from command
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true


func show_map() -> void:
	show()
	camera_2d.enabled = true


func hide_map() -> void:
	hide()
	camera_2d.enabled = false


func _spawn_room(room: Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)
	
	# Checks if the room was visited earlier (from a previous session)
	if room.selected && room.row < floors_climbed:
		new_map_room.show_selected()


func _connect_lines(room: Room) -> void:
	if room.next_rooms.is_empty():
		return
	
	for next: Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)


func _on_map_room_selected(room: Room) -> void:
	for map_room: MapRoom in rooms.get_children():
		# Checks if the room is in the same row
		if map_room.room.row == room.row:
			map_room.available = false
	
	last_room = room
	floors_climbed += 1
	map_exited.emit(room)
