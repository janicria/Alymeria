class_name MapGenerator
extends Node

const X_DIST := 25
const Y_DIST := 30
const PLACEMENT_RANDOMNESS := 5
const MAP_WIDTH := 5
const MONSTER_WEIGHT := 35
const SHOP_WEIGHT := 18
const HAVEN_WEIGHT := 25
const ELITE_WEIGHT := 22

var random_room_type_weights := {
	Room.Type.MONSTER: 0.0,
	Room.Type.HAVEN: 0.0,
	Room.Type.SHOP: 0.0,
	Room.Type.ELITE: 0.0
}
var random_room_type_total_weight := 0
var map_data: Array[Array]
var floors: int


func generate_map() -> Array[Array]:
	map_data = _generate_inital_grid()
	var starting_points := _get_random_starting_points()
	
	for j in starting_points:
		var current_j := j
		for i in floors - 1:
			current_j = _setup_connection(i, current_j)
	
	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()
	
	return map_data


func _generate_inital_grid() -> Array[Array]:
	var result: Array[Array] = []
	for biome: GameSave.Biome in GameSave.biome_floors:
		if biome == GameSave.current_biome:
			floors = GameSave.biome_floors[biome]
	
	for i in floors:
		var adjacent_rooms: Array[Room] = []
		
		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []
			
			# Boss floor has set y axis position with a larger offset
			if i == floors - 1:
				current_room.position.y = (i + 1) * -Y_DIST
			
			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	
	return result


func _get_random_starting_points() -> Array[int]:
	var result: Array[int] = []
	
	for i in MAP_WIDTH:
		result.append(i)
	
	while result.size() != 3:
		result.pop_at(randi_range(0, result.size() - 1))
	
	return result


func _setup_connection(i: int, j: int) -> int:
	var next_room: Room = null
	var current_room := map_data[i][j] as Room
	
	while !next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]
	
	current_room.next_rooms.append(next_room)
	
	return next_room.column


func _would_cross_existing_path(i: int, j: int, room: Room) -> bool:
	var left_neighbour: Room
	var right_neighbour: Room
	
	# if j == 0: there is no left neighbour
	if j > 0:
		left_neighbour = map_data[i][j - 1]
	# if j == (MAP_WIDTH - 1): there is no right neighbour
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]
	
	# can't cross right if right neighbour goes left
	if right_neighbour and room.column > j:
		for next_room: Room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true
	
	# can't cross left if left neighbour goes right
	if left_neighbour and room.column < j:
		for next_room: Room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true
	
	return false


func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[floors - 1][middle] as Room
	
	# edits connections to boss room
	for j in MAP_WIDTH:
		var current_room = map_data[floors - 2][j] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)
	
	boss_room.type = Room.Type.BOSS


# I honestly have no idea how this (weight systems) work, but it does
func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_WEIGHT
	random_room_type_weights[Room.Type.HAVEN] = MONSTER_WEIGHT + HAVEN_WEIGHT
	random_room_type_weights[Room.Type.SHOP] = MONSTER_WEIGHT + HAVEN_WEIGHT + SHOP_WEIGHT
	random_room_type_weights[Room.Type.ELITE] = random_room_type_weights[Room.Type.SHOP] + ELITE_WEIGHT
	
	random_room_type_total_weight = random_room_type_weights[Room.Type.ELITE]


func _setup_room_types() -> void:
	# first floor is always an enemy
	for room: Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MONSTER
	
	
	# 5th last floor is always treasure
	for room: Room in map_data[floors - 5]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.TREASURE
	
	# 2nd last floor is always either a haven or shop
	for room: Room in map_data[floors - 2]:
		if room.next_rooms.size() > 0:
			if randi_range(0, 1): room.type = Room.Type.HAVEN
			else: room.type = Room.Type.SHOP
	
	# all other non-boss rooms
	for current_floor in map_data:
		for room: Room in current_floor:
			for next_room: Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)


func _set_room_randomly(room: Room) -> void:
	var haven_below_4 := true
	var elite_below_3 := true
	var consecutive_shop := true
	var consecutive_haven := true
	
	var type_candidate: Room.Type
	
	while haven_below_4 or elite_below_3 or consecutive_shop or consecutive_haven:
		type_candidate = _get_random_room_type_by_weight()
		
		var is_haven := type_candidate == Room.Type.HAVEN
		var has_haven_parent := _room_has_parent_of_type(room, Room.Type.HAVEN)
		var is_shop := type_candidate == Room.Type.SHOP
		var has_shop_parent := _room_has_parent_of_type(room, Room.Type.SHOP)
		var is_elite := type_candidate == Room.Type.ELITE
		#var has_elite_parent := _room_has_parent_of_type(room, Room.Type.ELITE)
		
		
		haven_below_4 = is_haven and room.row < 3
		elite_below_3 = is_elite and room.row < 2
		consecutive_haven = is_haven and has_haven_parent
		consecutive_shop = is_shop and has_shop_parent
	
	room.type = type_candidate


func _room_has_parent_of_type(room: Room, type: Room.Type) -> bool:
	var parents: Array[Room] = []
	
	# left parent (floor 0 rooms have no parents)
	if room.column > 0 and room.row > 0:
		var parent_candiate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candiate.next_rooms.has(room):
			parents.append(parent_candiate)
	
	# middle parent (floor 0 rooms have no parents)
	if room.row > 0:
		var parent_candiate := map_data[room.row - 1][room.column] as Room
		if parent_candiate.next_rooms.has(room):
			parents.append(parent_candiate)
	
	# right parent (floor 0 rooms have no parents)
	if room.column < MAP_WIDTH - 1 and room.row > 0:
		var parent_candiate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candiate.next_rooms.has(room):
			parents.append(parent_candiate)
	
	for parent: Room in parents:
		if parent.type == type:
			return true
	
	return false


func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)
	
	for type: Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	print("error generating room type")
	return Room.Type.MONSTER
