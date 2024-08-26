extends Node

var number_of_enemies:int
var number_of_allies:int

var number_generator 
var number_granter

## Enemy 1
var enemy_1_name
var enemy_1_health:int

# No touchy
var turn_number:int
var turn_letter = ''


var enemy_1_block:int
var enemy_1_intent_type = ''
var enemy_1_turn_number:int

var enemy_1_atk_counter:int
var enemy_1_block_counter:int
var enemy_1_special_counter:int
var enemy_1_summon_counter:int

var enemy_1_atk_damage:int
var enemy_1_atk_repeats:int


## Enemy 2
var enemy_2_name
var enemy_2_health:int

# No touchy
var enemy_2_block:int
var enemy_2_intent_type = ''
var enemy_2_turn_number:int

var enemy_2_atk_counter:int
var enemy_2_block_counter:int
var enemy_2_special_counter:int
var enemy_2_summon_counter:int

var enemy_2_atk_damage:int
var enemy_2_atk_repeats:int


## Enemy 3
var enemy_3_name
var enemy_3_health:int

# No touchy
var enemy_3_block:int
var enemy_3_intent_type = ''
var enemy_3_turn_number:int

var enemy_3_atk_counter:int
var enemy_3_block_counter:int
var enemy_3_special_counter:int
var enemy_3_summon_counter:int

var enemy_3_atk_damage:int
var enemy_3_atk_repeats:int


## Enemy 4
var enemy_4_name
var enemy_4_health:int

# No touchy
var enemy_4_block:int
var enemy_4_intent_type = ''
var enemy_4_turn_number:int

var enemy_4_atk_counter:int
var enemy_4_block_counter:int
var enemy_4_special_counter:int
var enemy_4_summon_counter:int

var enemy_4_atk_damage:int
var enemy_4_atk_repeats:int

## Enemy 5
var enemy_5_name:int
var enemy_5_health:int

# No touchy
var enemy_5_block:int
var enemy_5_intent_type = ''
var enemy_5_turn_number:int

var enemy_5_atk_counter:int
var enemy_5_block_counter:int
var enemy_5_special_counter:int
var enemy_5_summon_counter:int

var enemy_5_atk_damage:int
var enemy_5_atk_repeats:int
var enemy_1_block_amount:int

func new_turn():
	enemy_1_turn_number +=1
	if enemy_1_turn_number == 1: # Add more if needed
		enemy_1_intent_type = 'ATK'
	if enemy_1_turn_number == 2:
		enemy_1_intent_type = 'SPECIAL'
	if enemy_1_turn_number == 3:
		enemy_1_intent_type = 'SPECIAL'
	if enemy_1_turn_number == 4:
		enemy_1_intent_type = 'SUMMON'

	if enemy_1_intent_type == 'ATK':
		enemy_1_atk_counter +=1
	if enemy_1_intent_type == 'BLOCK':
		enemy_1_block_counter +=1
	if enemy_1_intent_type == 'SPECIAL':
		enemy_1_special_counter +=1
	if enemy_1_intent_type == 'SUMMON':
		enemy_1_summon_counter +=1

	if enemy_1_name == 'Infected scientist':
		if enemy_1_atk_counter == 1: # Edit with differnt intents 
			enemy_1_atk_damage = 13 # Add more if needed
			enemy_1_atk_repeats = 1

		if enemy_1_special_counter == 1:
			number_generator = RandomNumberGenerator.new()
			number_granter = number_generator.randi_range(0, 1)
			if number_granter == 1:
				enemy_1_atk_damage = 8
				enemy_1_block_amount = 4
			else:
				enemy_1_block_amount = 4

		if enemy_1_special_counter == 2:
			enemy_1_atk_damage = 8
			enemy_1_block_amount = 4



	enemy_2_turn_number +=1
	if enemy_2_turn_number == 1: # Add more if needed
		enemy_2_intent_type = 'ATK'
	if enemy_2_turn_number == 2:
		enemy_2_intent_type = 'BLOCK'
	if enemy_2_turn_number == 3:
		enemy_2_intent_type = 'SPECIAL'
	if enemy_2_turn_number == 4:
		enemy_2_intent_type = 'SUMMON'

	if enemy_2_intent_type == 'ATK':
		enemy_2_atk_counter +=1
	if enemy_2_intent_type == 'BLOCK':
		enemy_2_block_counter +=1
	if enemy_2_intent_type == 'SPECIAL':
		enemy_2_special_counter +=1
	if enemy_2_intent_type == 'SUMMON':
		enemy_2_summon_counter +=1

	if enemy_2_atk_counter == 1: # Edit with differnt intents 
		enemy_2_atk_damage = 0 # Add more if needed
		enemy_2_atk_repeats = 0

	if enemy_2_atk_counter == 2:
		enemy_2_atk_damage = 0
		enemy_2_atk_repeats = 0

	enemy_3_turn_number +=1
	if enemy_3_turn_number == 1: # Add more if needed
		enemy_3_intent_type = 'ATK'
	if enemy_3_turn_number == 2:
		enemy_3_intent_type = 'BLOCK'
	if enemy_3_turn_number == 3:
		enemy_3_intent_type = 'SPECIAL'
	if enemy_3_turn_number == 4:
		enemy_3_intent_type = 'SUMMON'

	if enemy_3_intent_type == 'ATK':
		enemy_3_atk_counter +=1
	if enemy_3_intent_type == 'BLOCK':
		enemy_3_block_counter +=1
	if enemy_3_intent_type == 'SPECIAL':
		enemy_3_special_counter +=1
	if enemy_3_intent_type == 'SUMMON':
		enemy_3_summon_counter +=1

	if enemy_3_atk_counter == 1: # Edit with differnt intents 
		enemy_3_atk_damage = 0 # Add more if needed
		enemy_3_atk_repeats = 0

	if enemy_3_atk_counter == 2:
		enemy_3_atk_damage = 0
		enemy_3_atk_repeats = 0

	enemy_4_turn_number +=1
	if enemy_4_turn_number == 1: # Add more if needed
		enemy_4_intent_type = 'ATK'
	if enemy_4_turn_number == 2:
		enemy_4_intent_type = 'BLOCK'
	if enemy_4_turn_number == 3:
		enemy_4_intent_type = 'SPECIAL'
	if enemy_4_turn_number == 4:
		enemy_4_intent_type = 'SUMMON'

	if enemy_4_intent_type == 'ATK':
		enemy_4_atk_counter +=1
	if enemy_4_intent_type == 'BLOCK':
		enemy_4_block_counter +=1
	if enemy_4_intent_type == 'SPECIAL':
		enemy_4_special_counter +=1
	if enemy_4_intent_type == 'SUMMON':
		enemy_4_summon_counter +=1

	if enemy_4_atk_counter == 1: # Edit with differnt intents 
		enemy_4_atk_damage = 0 # Add more if needed
		enemy_4_atk_repeats = 0

	if enemy_4_atk_counter == 2:
		enemy_4_atk_damage = 0
		enemy_4_atk_repeats = 0

	enemy_5_turn_number +=1
	if enemy_5_turn_number == 1: # Add more if needed
		enemy_5_intent_type = 'ATK'
	if enemy_5_turn_number == 2:
		enemy_5_intent_type = 'BLOCK'
	if enemy_5_turn_number == 3:
		enemy_5_intent_type = 'SPECIAL'
	if enemy_5_turn_number == 4:
		enemy_5_intent_type = 'SUMMON'

	if enemy_5_intent_type == 'ATK':
		enemy_5_atk_counter +=1
	if enemy_5_intent_type == 'BLOCK':
		enemy_5_block_counter +=1
	if enemy_5_intent_type == 'SPECIAL':
		enemy_5_special_counter +=1
	if enemy_5_intent_type == 'SUMMON':
		enemy_5_summon_counter +=1

	if enemy_5_atk_counter == 1: # Edit with differnt intents 
		enemy_5_atk_damage = 0 # Add more if needed
		enemy_5_atk_repeats = 0

	if enemy_5_atk_counter == 2:
		enemy_5_atk_damage = 0
		enemy_5_atk_repeats = 0

func rdm_a1_scientist():
	number_of_enemies = 1
	enemy_1_name = 'Infected scientist'
	enemy_1_health = 25
	enemy_1_atk_damage

var ally_1_health:int
var ally_2_health:int
var ally_3_health:int
var ally_4_health:int
var ally_5_health:int
var ally_6_health:int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
