extends Node

class_name player_old
@export var inventory : Inventory

var max_health:int = 30
var health = max_health
var max_battery = 80
var battery = 48
var turn_letter = 1
var turn_number = 1

var has_critical = false
var genetic_algorithm_level = 0
var dodge_level = 0
var damage_up_level = 0
var defense_up_level = 0
var battery_up_level = 0
var shields_level = 0
var thorns_level = 0
var critical_level = 0

var has_confused = false
var stunned_level = 0
var sightless_level = 0
var memeory_drain_level = 0
var damaged_level = 0
var electro_level = 0
var injured_level = 0


func new_turn():
	turn_letter += 1
	if turn_letter > 4:
		turn_letter = 1
		turn_number +=1
	stunned_level -= 1
	sightless_level -= 1
	memeory_drain_level -= 1
	damaged_level -= 1
	electro_level -= 1
	injured_level -= 1
	dodge_level  -= 1
	damage_up_level -= 1
	defense_up_level -= 1
	battery_up_level -= 1
	shields_level -= 1
	thorns_level -= 1
	critical_level -= 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	damage_calculation = 
