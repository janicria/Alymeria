extends Node

var level_select_rng = RandomNumberGenerator.new()
var level_selector:int = level_select_rng.randf_range(1, 11)
var room_select_rng = RandomNumberGenerator.new()
var room_selector:int = level_select_rng.randf_range(0, 10)
var die:bool = true
var dajgd:int
var funzies_generator
var funzies_selector
var funzies_multiplier
var funzies_tracker = 1
var funzies_printer:int



func _ready():
	pass

func _process(delta):
	pass
	#seed_tracker()
	#real_seeds()
	#funzies()
	#regular_combat_finished()
	#regular_combat_finished()
	#deadly_combat_finished()
	#boss_combat_finished()
	#regular_data_chip()
	#rich_print_program_loader()
	counter()
	counter()

var gold:int
var number_granter:int
var biome_bonus_gold = 10
var potion_chance
var potion_chance_last_combat = 20
var potion_given = false
var double_potion_given = false
var number_generator
var combat_reward_locker = false
var boss_reward_locker = false
var deadly_reward_locker = false
var total_number_of_programs:int = 6
var rich_print_program

func regular_combat_finished():
	if not combat_reward_locker:
		combat_reward_locker = true
		# Gold calc
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randi_range(10, 30)
		gold += (number_granter + biome_bonus_gold)
		# Pot calc
		if potion_given:
			potion_chance = 0.2
			potion_chance_last_combat = 0.2
			potion_given = false
		if double_potion_given:
			potion_chance = 0.2
			potion_chance_last_combat = 0.2
			double_potion_given = false
		potion_chance = 20 + (potion_chance_last_combat * 0.7)
		potion_chance_last_combat = potion_chance
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randf_range(0, 100)
		if potion_chance > number_granter:
			potion_given = true
		# Data chip calc
		regular_data_chip()
		print('Gold - ' +str(gold) + '   |   Pot chance - ' +str(potion_chance) + ' vs ' + str(number_granter) + ' / Got 1 pot? - ' + str(potion_given))

func boss_combat_finished():
	if not boss_reward_locker:
		boss_reward_locker = true
		# Gold calc
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randi_range(10, 30)
		gold += (number_granter + biome_bonus_gold) * 2.5
		# Pot calc
		if potion_given:
			potion_chance = 20
			potion_chance_last_combat = 20
			potion_given = false
		if double_potion_given:
			potion_chance = 20
			potion_chance_last_combat = 20
			double_potion_given = false
		potion_chance = 20 + (potion_chance_last_combat * 0.7)
		potion_chance_last_combat = potion_chance
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randf_range(0, 100)
		if potion_chance > number_granter:
			double_potion_given = true
		else:
			potion_given = true
		# Data chip calc
		print('Gold - ' +str(gold) + '   |   Pot chance - ' +str(potion_chance) + ' vs ' + str(number_granter) + ' / Got 1 pot? - ' + str(potion_given) + ' / Got 2 pot? - ' +str(double_potion_given))

func deadly_combat_finished():
	if not deadly_reward_locker:
		deadly_reward_locker = true
		# Gold calc
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randi_range(10, 30)
		gold += (number_granter + biome_bonus_gold) * 1.6
		# Pot calc
		if potion_given:
			potion_chance = 20
			potion_chance_last_combat = 20
			potion_given = false
		if double_potion_given:
			potion_chance = 20
			potion_chance_last_combat = 20
			double_potion_given = false
		potion_chance = 20 + (potion_chance_last_combat * 0.7)
		potion_chance += 40
		potion_chance_last_combat = potion_chance
		number_generator = RandomNumberGenerator.new()
		number_granter = number_generator.randf_range(0, 100)
		if potion_chance > number_granter and potion_chance > 99:
			double_potion_given = true
		elif potion_chance > number_granter:
			potion_given = true
		# Data chip calc
		regular_data_chip()
		print('Gold - ' +str(gold) + '   |   Pot chance - ' +str(potion_chance) + ' vs ' + str(number_granter) + ' / Got 1 pot? - ' + str(potion_given) + ' / Got 2 pot? - ' +str(double_potion_given))

func rich_print_program_loader():
	if rich_print_program == 1:
		print_rich('program 1')
		rich_print_program = 0
	if rich_print_program == 2:
		print_rich('program 2')
		rich_print_program = 0
	if rich_print_program == 3:
		print_rich('program 3')
		rich_print_program = 0
	if rich_print_program == 4:
		print_rich('program 4')
	if rich_print_program == 5:
		rich_print_program = 0
		print_rich('program 5')
	if rich_print_program == 6:
		rich_print_program = 0
		print_rich('program 6')

func regular_data_chip():
	give_random_program()
	give_random_program()
	give_random_program()

func give_random_program():
	number_generator = RandomNumberGenerator.new()
	number_granter = number_generator.randi_range(1, total_number_of_programs)
	rich_print_program = number_granter

func give_upgraded_program():
	pass

func give_double_upgraded_program():
#	ProgramName_upgrade_3_stat_increase += 1
#	ProgramName_upgrade_3_stat_increase += 1
	pass

var Heatsinks_in_deck = false
var Heatsinks_upgrade_2
var Heatsinks_upgrade_3
var Heatsinks_played


func counter():
	if not Heatsinks_in_deck:
		Heatsinks_in_deck = true
		print(Heatsinks_in_deck)


func funzies():
	funzies_generator = RandomNumberGenerator.new()
	funzies_selector = funzies_generator.randf_range(0, 3)
	funzies_multiplier  = funzies_selector * funzies_tracker
	funzies_tracker = funzies_multiplier + funzies_selector
	funzies_printer = funzies_generator.randf_range(0, funzies_tracker)
	if funzies_printer > 100000000000000000:
		funzies_tracker = funzies_tracker / 4
		funzies_printer = funzies_tracker / 4
		#funzies_multiplier = funzies_printer / 2
	print(str(funzies_printer) + str(funzies_printer / 2) + str(funzies_printer / 8) + str(funzies_printer / 16) + str(funzies_printer / 32) + str(funzies_printer / 64) + str(funzies_printer / 128) + str(funzies_printer / 256) + str(funzies_printer / 512))
	#if level_selector < 5:
	#	question_room()
	#if level_selector > 4 and level_selector <9:
	#	emey()
	#if level_selector == 9:
	#	money()
	#if level_selector == 10:
	#	reward()
	#hovering_selector()
	pass

var seed_generator1
var seed_selector1
var seed_counter1:int
var seed_storer1:String
func seed_tracker():
	seed_generator1 = RandomNumberGenerator.new()
	seed_selector1 = seed_generator1.randi_range(0, 1000)
	seed_counter1 += 1
	seed_storer1 = str(seed_counter1) + '.' +str(seed_selector1)
	print(seed_storer1)

var seed_generator
var seed_boss_selector
var seed_enemy_selector
var seed_event_selector
var seed_mini_selector
var seed_shop_selector
var seed_loot_selector
var seed_locker:bool = false
var replace_with_in_act_how_many_different_boss = 10
var replace_with_in_act_how_many_different_enemy = 12
var replace_with_in_act_how_many_different_event = 213
var replace_with_in_act_how_many_different_mini = 34
var replace_with_in_act_how_many_different_shop =34
var replace_with_in_act_how_many_different_loot =34
var seed

func real_seeds():
	if not seed_locker:
		seed_locker = true
		seed_generator = RandomNumberGenerator.new()
		seed_boss_selector = seed_generator.randi_range(0, replace_with_in_act_how_many_different_boss)
		seed_generator = RandomNumberGenerator.new()
		seed_enemy_selector = seed_generator.randi_range(0, replace_with_in_act_how_many_different_enemy)
		seed_generator = RandomNumberGenerator.new()
		seed_event_selector = seed_generator.randi_range(0, replace_with_in_act_how_many_different_event)
		seed_generator = RandomNumberGenerator.new()
		seed_mini_selector = seed_generator.randi_range(0, replace_with_in_act_how_many_different_mini)
		seed_generator = RandomNumberGenerator.new()
		seed_shop_selector = seed_generator.randi_range(0, replace_with_in_act_how_many_different_shop)
		seed_generator = RandomNumberGenerator.new()
		seed_loot_selector = seed_generator.randi_range(0, replace_with_in_act_how_many_different_loot)
		seed = str(seed_boss_selector) + '.' +str(seed_enemy_selector) + '.' +str(seed_event_selector) + '.' +str(seed_mini_selector) + '.' +str(seed_shop_selector) + '.' +str(seed_loot_selector)
		print(seed)

func question_room():
#	print('? - ' +str(room_selector))
	pass
	dice()
func emey():
#	print('emey - ' +str(room_selector))
	pass
func money():
#	print('money - ' +str(room_selector))
	pass
func reward():
#	print('reward! - ' +str(room_selector))
	pass
func dice():
	if die:
		print('You see dice you can either eat them or roll them lol')
		print('Eat: Gain 347982 hp')
		print('Roll: Implosion')
		die = false
	if Input.is_action_just_pressed("e_pressed"):
		print('Holy shit you got +347982 hp')
	if dajgd == 1:
		get_tree().quit()
	if Input.is_action_just_pressed("r_pressed"):
		print('Get imploaded lmao')
		dajgd +=1
