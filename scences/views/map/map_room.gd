class_name MapRoom
extends Area2D

signal selected(room: Room)

const ICONS := { # Element 1 (Vector2) = scale
	Room.Type.NOT_ASSIGNED: [null, Vector2.ONE],
	Room.Type.MONSTER: [preload("res://assets/art/objects/tile_0103.png"), Vector2.ONE],
	Room.Type.TREASURE: [preload("res://assets/art/objects/tile_0089.png"), Vector2.ONE],
	Room.Type.HAVEN: [preload("res://assets/ui/big_heart.png"), Vector2(0.6, 0.6)],
	Room.Type.SHOP: [preload("res://assets/ui/gold.png"), Vector2(0.6, 0.6)],
	Room.Type.ELITE: [preload("res://assets/art/objects/tile_0105.png"), Vector2.ONE],
	Room.Type.BOSS: [preload("res://assets/art/objects/tile_0107.png"), Vector2(1.6, 1.6)]
	
}

@onready var line_2d: Line2D = %Line2D
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var timer: Timer = $Timer

var available := false : set = set_available
var room: Room : set = set_room


func set_available(new_value: bool) -> void:
	available = new_value
	
	if available:
		animation_player.play("highlight")
	elif !room.selected: # Skipped rooms
		animation_player.play("RESET")


func set_room(new_data: Room) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360)
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]


func show_selected() -> void:
	line_2d.modulate = Color.WHITE


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Safety for selecting unavailable rooms / right clicking rooms
	if !available or !event.is_action_pressed("left_mouse_pressed"):
		return 
	
	room.selected = true
	animation_player.play("select")


# Keyframe called by AnimationPlayer when the "select" anim ends
func _on_map_room_selected() -> void:
	selected.emit(room)
