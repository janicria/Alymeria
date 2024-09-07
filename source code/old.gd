extends Node

var seed_generator
var seed_boss_selector
var seed_enemy_selector
var seed_event_selector
var seed_mini_selector
var seed_shop_selector
var seed_loot_selector
var seed_locker:bool = false
var replace_with_how_many_different_in_act = 1
var seed_boss = 2
var seed_enemy
var seed_event
var seed_mini
var seed_shop
var seed_loot
var seed_chances
func seed_granter():
	if not seed_locker:
		seed_locker = true
		seed_generator = RandomNumberGenerator.new()
		seed_boss_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_enemy_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_event_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_mini_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_shop_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		seed_generator = RandomNumberGenerator.new()
		seed_loot_selector = seed_generator.randi_range(0, replace_with_how_many_different_in_act)
		#seed = str(seed_boss_selector) + '.' +str(seed_enemy_selector) + '.' +str(seed_event_selector) + '.' +str(seed_mini_selector) + '.' +str(seed_shop_selector) + '.' +str(seed_loot_selector)
		seed_boss = str(seed_boss_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, 1))
		seed_mini = str(seed_mini_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))+str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		#seed_loot  = str(seed_enemy_selector) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		seed_enemy = str(seed_enemy_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		seed_event  = str(seed_enemy_selector) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		#seed_shop = str(seed_enemy_selector) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(1, replace_with_how_many_different_in_act)) +str(seed_generator.randi_range(0, replace_with_how_many_different_in_act))
		seed_chances = (str(seed_boss) +'-' +str(seed_mini) +'-' +str(seed_enemy) +'-' +str(seed_event))
		#print('Seed - ' +str(seed))

var floor_lineup
var floor_enemy_chance
var floor_event_chance
var floor_event_1
var floor_event_2
var floor_event_3
var floor_event_4
var floor_event_5
var floor_event_6
var floor_event_7
var floor_event_8
var floor_event_9
var floor_event_10
var floor_event_11
var floor_event_12
var floor_event_13
var floor_event_14
var floor_event_15
var floor_event_16
var floor_event_17
var floor_event_18
var floor_event_19
var floor_event_20
var floor_event_21
var floor_event_22
var floor_event_23
var floor_event_24
var floor_event_25
var floor_event_26
var floor_event_27
var floor_event_28
var floor_event_29
var floor_event_30
var floor_event_31
var floor_lineup_act_1
var floor_lineup_act_2
var floor_lineup_act_3
var floor_lineup_act_4
var floor_lineup_act_5
var floor_lineup_act_6
var floor_lineup_act_7
var floor_chance_counter:int 
var floor_lock_generation:bool = false
var seed

func room_selector():
	#print(floor_chance_counter)
	if not floor_lock_generation:
		floor_enemy_chance = seed_generator.randi_range(1, 100)
		floor_event_chance = seed_generator.randi_range(1, 90)
		seed_generator = RandomNumberGenerator.new()
		if floor_chance_counter == 1:
			if floor_event_chance < floor_enemy_chance:
				floor_event_1 = 'E'
			else:
				floor_event_1 = 'R'
		if floor_chance_counter == 2:
			if floor_event_chance < floor_enemy_chance:
				floor_event_2 = 'E'
			else:
				floor_event_2 = 'R'
		if floor_chance_counter == 3:
			if floor_event_chance < floor_enemy_chance:
				floor_event_3 = 'E'
			else:
				floor_event_3 = 'R'
		if floor_chance_counter == 4:
			if floor_event_chance < floor_enemy_chance:
				floor_event_4 = 'E'
			else:
				floor_event_4 = 'R'
		if floor_chance_counter == 5:
			if floor_event_chance < floor_enemy_chance:
				floor_event_5 = 'E'
			else:
				floor_event_5 = 'R'
		if floor_chance_counter == 6:
			if floor_event_chance < floor_enemy_chance:
				floor_event_6 = 'E'
			else:
				floor_event_6 = 'R'
		if floor_chance_counter == 7:
			if floor_event_chance < floor_enemy_chance:
				floor_event_7 = 'E'
			else:
				floor_event_7 = 'R'
		if floor_chance_counter == 8:
			if floor_event_chance < floor_enemy_chance:
				floor_event_8 = 'E'
			else:
				floor_event_8 = 'R'
		if floor_chance_counter == 9:
			if floor_event_chance < floor_enemy_chance:
				floor_event_9 = 'E'
			else:
				floor_event_9 = 'R'
		if floor_chance_counter == 10:
			if floor_event_chance < floor_enemy_chance:
				floor_event_10 = 'E'
			else:
				floor_event_10 = 'R'
		if floor_chance_counter == 11:
			if floor_event_chance < floor_enemy_chance:
				floor_event_11 = 'E'
			else:
				floor_event_11 = 'R'
		if floor_chance_counter == 12:
			if floor_event_chance < floor_enemy_chance:
				floor_event_12 = 'E'
			else:
				floor_event_12 = 'R'
		if floor_chance_counter == 13:
			if floor_event_chance < floor_enemy_chance:
				floor_event_13 = 'E'
			else:
				floor_event_13 = 'R'
		if floor_chance_counter == 14:
			if floor_event_chance < floor_enemy_chance:
				floor_event_14 = 'E'
			else:
				floor_event_14 = 'R'
		if floor_chance_counter == 15:
			if floor_event_chance < floor_enemy_chance:
				floor_event_15 = 'E'
			else:
				floor_event_15 = 'R'
		if floor_chance_counter == 16:
			if floor_event_chance < floor_enemy_chance:
				floor_event_16 = 'E'
			else:
				floor_event_16 = 'R'
		if floor_chance_counter == 17:
			if floor_event_chance < floor_enemy_chance:
				floor_event_17 = 'E'
			else:
				floor_event_17 = 'R'
		if floor_chance_counter == 18:
			if floor_event_chance < floor_enemy_chance:
				floor_event_18 = 'E'
			else:
				floor_event_18 = 'R'
		if floor_chance_counter == 19:
			if floor_event_chance < floor_enemy_chance:
				floor_event_19 = 'E'
			else:
				floor_event_19 = 'R'
		if floor_chance_counter == 20:
			if floor_event_chance < floor_enemy_chance:
				floor_event_20 = 'E'
			else:
				floor_event_20 = 'R'
		if floor_chance_counter == 21:
			if floor_event_chance < floor_enemy_chance:
				floor_event_21 = 'E'
			else:
				floor_event_21 = 'R'
		if floor_chance_counter == 22:
			if floor_event_chance < floor_enemy_chance:
				floor_event_22 = 'E'
			else:
				floor_event_22 = 'R'
		if floor_chance_counter == 23:
			if floor_event_chance < floor_enemy_chance:
				floor_event_23 = 'E'
			else:
				floor_event_23 = 'R'
		if floor_chance_counter == 24:
			if floor_event_chance < floor_enemy_chance:
				floor_event_24 = 'E'
			else:
				floor_event_24 = 'R'
		if floor_chance_counter == 25:
			if floor_event_chance < floor_enemy_chance:
				floor_event_25 = 'E'
			else:
				floor_event_25 = 'R'
		if floor_chance_counter == 26:
			if floor_event_chance < floor_enemy_chance:
				floor_event_26 = 'E'
			else:
				floor_event_26 = 'R'
		if floor_chance_counter == 27:
			if floor_event_chance < floor_enemy_chance:
				floor_event_27 = 'E'
			else:
				floor_event_27 = 'R'
		if floor_chance_counter == 28:
			if floor_event_chance < floor_enemy_chance:
				floor_event_28 = 'E'
			else:
				floor_event_28 = 'R'
		floor_chance_counter += 1
		if floor_chance_counter == 30:
			floor_lock_generation = true
			floor_lineup_act_1 = 'RE'  + floor_event_2 + floor_event_3 + 'CR' + floor_event_4 + floor_event_5 + 'CLB-'
			floor_lineup_act_2 = 'CS' + floor_event_6 + floor_event_7 + floor_event_8 + 'LC' + floor_event_9 + floor_event_10 +'SL' +floor_event_11 + floor_event_12 + 'RCB-' 
			floor_lineup_act_3 = 'CR' + floor_event_13 + floor_event_14 + 'SL' +floor_event_15 + floor_event_16 + floor_event_17 + 'C' + floor_event_18 + 'L-'
			floor_lineup_act_4 = floor_event_19 + floor_event_20 + 'RCB-'
			floor_lineup_act_5 = 'CS' + floor_event_27 + floor_event_28 + floor_event_26 + 'CRL-'
			floor_lineup_act_6 = floor_event_1 + 'EC' + floor_event_21 + floor_event_22 + floor_event_23 + floor_event_24 +'CL' + floor_event_25 + 'RCLS-'
			floor_lineup_act_7 = 'CEELCEB'
			floor_lineup = str(floor_lineup_act_1)  +str(floor_lineup_act_2)  +str(floor_lineup_act_3)  +str(floor_lineup_act_4)  +str(floor_lineup_act_5)  + str(floor_lineup_act_6) + str(floor_lineup_act_7)
			#'RXXXCRXXCMB.CXXMCXSXMXXSCB.CRXSXXXCM.XRCB.CSXXXMCXXCB.CXXSMCMXXCB.CSEEMCEB'
			seed = floor_lineup + '.' + seed_chances
			print('Seed: ' + seed)


## Maybs ost names
# Defense Construct #4086FE12 - Main menu and boot intro
# Limited options - Event and reward music
# Warning: Exteral plating damaged - Comabt music
# ERROR: Out of memory! - Combat music
# Buy something! - Shop music
# It's Jerry! - All interactions with jerry except for jerry bossfight
# The core infector - The core infector bossfight
# The snail that started it all - Jerry bossfight
# Thank you for playtesting! - Credits

## Cult of Snal
# "Snal" gives order via 'The Blessed Parchment' a book in the center of the churchs main cathedrial which text is magically changed by "Snal"

## Act 1 Events
# 
## Act 1 Enemies
# Infected scientist (Small Health) (Attacks for 13 -> 50% - Applies 4 Critical and 6 shield -> Attacks for 8 and shields 4 OR 50% - Attacks for 8 and shields 4 -> Applies 4 Critical and 6 shield THEN -> Repeats T1 - T3
## Act 2 Events
# Jerry the slime! (rdm_a2_jerry) -> Free help!: Gain Jerry as an ally OR Free potion!: Obtain a random potion OR Free infuser!: Obtain a random infuser OR Fight: Fight Jerry
## Act 2 Enemies
# Jerry the slime (set_a2_jerry) (Lethal) -> 
## Act 3 Events
# Thieving gang -> Pay up: Lose gold: ((Current gold / 2) - 35 OR Bribe: Pay 150 - 200 gold, obtain a random proccessor OR Hire: Pay, 80 gold, Gain x1 thief as ally (Tanks 20 HP for you, deals small DMG each turn) (Can do multiple times)
# Inn -> Stay a night: Pay 50 gold, free safe haven OR Leave
# Heist -> Help thieves: Gain (80-120 gold), 30% of betral (lose 30 - 80 gold) OR Help nobleman: Gain (30 - 50 gold)
# Street robbery -> Intervene: Take (5-15) damage, obtain LVL 1 merchants favour OR Ignore: Leave, pay 10% more on all purchases in cybercity
## Act 3 Enemies
# 
## Act 4 Events
# Kitchen (Same as safe haven)
## Act 4 Enemies
# Palace guards (Two of them, medium health, if both are alive: 30% to apply small shield to both guards (if one is alive applies small-medium shield to itself (~60-80% TOTAL shield gained from both guards being alive), 50% chance to apply medium DMG, 20% to apply 2 stunned ONCE)
## Act 5 Events
# Find a damaged boss data chip in ground (Same as boss data chip but only three cards)
# Another Jerry the slime! (rdm_a5_jerry) -> Free help!: Gain Jerry as an ally OR Free processor!: Obtain a free processor OR Fight!: Fight this Jerry
# [Name TBD] -> Gain 300 gold, obtain a LVL 3 Curse of greed OR Lose 50 gold
## Act 5 Enemies
# Jerry the slime (set_a5_jerry) (Lethal) (A lot harder than set_a2_jerry) -> 
# Swarm of bats (Four of them, small health,=, 60% chance of small-medium DMG ATK, 40% chance of applying stunned ATK ONCE)
## Act 6 Events
# Starfield Industries construct repair shop (rdm_a6_repair) -> Purchase repairs: Pay 35 gold. heal to max health OR Purchase batteries: Pay 65 gold, Regenerate 30% of max battery charge OR Leave
# Phil & Co. processor shop (rdm_a6_processor) -> Regular processor: Pay 100 gold, obtain a random LVL 1 processor (you get to see option) OR Premium processor: Pay 120 gold, obtain a random LVL 2 processor (you get to see option) OR Ultra Deluxe processor: Pay 140 gold, obtain a random LVL 3 processor (you get to see option) OR Leave
# Phil & Co. Genreal shop (rdm_a1_genreal) -> Purchase data chip: Pay 30 gold, obtain a random data chip OR Purchase TWO! data chips: Pay 50 gold, obtain two random data chips OR Purchase Ultra Deluxe data chip bundle EX: Pay 60 gold, obtain a random data chip and a boss data chip OR Leg of Jerry: Pay 200 gold, obtain Leg of Jerry OR Leave
## Act 7 Enemies
# Infected bruiser + Infected sorcerer
# Infected sentry (Medium - High health), ATK for 20 -> ATK for 30 -> Give itself 5 damage up -> Repeat
# 
# Fungal construct (Lethal) (High Health) Gives itself 2 defense up -> Attacks for 3 five times -> Gives itself 2 damage up -> Repeat
# Spore spreader (Lethal) (Medium health) Summons spore striker and defender as allies -> Applies confused  and 2 injured -> Attacks for 10 three times -> Repeats T2 - T3
# Spore striker (Ally) (Medium health) (Is summoned -> Attacks for 25 -> Attacks for 10 twice -> Repeats T2 - T3)
# Spore defender (Ally) (Small health) (Is summoned -> Applies 30 shield to what summoned it -> Applies 20 shield to all allies but itslef -> Infects you with a Spore infection -> Repeats T2 - T4
# Infected Archmage (Lethal)
# Core Infector [STD] (Boss) (Very high health) (Infects you with a Spore infection  Applies 4 Stunned and 3 Injured to EVERYONE -> Attacks for 35 -> Attacks for 15 twice -> Summons a Infector bodyguard -> Applies a medium buff to all allies -> Attacks for 40 -> Attacks for 10 twice -> Repeats T5 - T7)
# Core Infector [DTH] (Boss) (Very high health) (Infects you with 2 Spore infections  Summons an Infector bodygaurd  Applies 4 Stunned and 3 Injured to EVERYONE -> Attacks for 40 -> Applies a medium buff to itself -> Attacks for 15 twice -> Applies 3 thorns to all allies -> Repeats T2 - T4)
# Infector bodyguard (Ally) (High health) (Is summoned -> Attacks for 20 -> Applies either 1 injured or 2 Damaged -> Attacks for 25 -> Applies 2 defense up to Core Infector -> Repeats T2 - T4)

## Debuffs
# Stunned (Attacks deal 25% less DMG, decreases by 1 each turn)
# Sightless (Attacks deal 40% less DMG, decreases by 1 each turn))
# Memory drain (Lose X max memory)
# Confusion (Skip to a random turn after each turn i.e: 3? -> 1?, turn letter resets to TA when debuff is lost)
# Damaged (Take X additional damage, decreases by 1 each turn)
# Electrocuted (Take X DMG at the end of each turn, allies with electrocuted gain X - 1 electrocuted at the start of each turn. Decreases by 1 each turn.)
# Injured (Take 40% more damage from attacks, decreases by 1 each turn)

## Buffs
# Genetic algorithm (Decrease X random debuffs by one each turn)
# Dodge (Negative damage from enemies 40% of the time, decreases by 1 each turn)
# Damage up (Deal X additional DMG)
# Defense up (Take X less DMG)
# Battery up (Recharge X more battery charges)
# Critical (Attacks have a (X times 10)% chance to deal double damage, decreases by 1 each turn)
# Spare battery charges (The next ATK you recive which decreases battery charges cannot decrease more than 1 battery charge)
# Thorns (Upon reciving damage deal X damage to what attacked you)

## Safe havens
# Option - Repair plating (Heal to max HP)
# Option - Forage for biofuel (Regenerate 40% of max battery charge)
# Option - Enhance programs (Enhance two programs (Special 1st upgrade, ever upgrade after increases stats by 40% of current stats, then 30%, then 20%, etc)
# Option - Downgrade & Upgrade - Remove one processor, upgrade one processor, enhance a program

## After each combat
# * Obtain gold: ((10 - 30) + Biome bonus) * Enemy type (Biome bonus = 0 -> 2 -> 4 -> 6, etc) (Enemy type: If Regular = 1, if event = 1.2, if mini = 1.6, if boss = 2.5 if biome > 4, if biome <3 = 2)
# ** Obtain data chip:
# ** If Regular = Obtain one out of four cards with 60% for LVL 1, 35% for LVL 2, 5% for LVL 3 and 90% chance for no enhancement and 10% for one)
# ** If Event = Obtain one out of three cards with 50% for LVL 1, 40% for LVL 2, 10% for LVL 3 and 85% chance for no enhancement and 15% for one)
# ** If Mini = Obtain one out of four cards with 40% for LVL 1, 30% for LVL 2, 30% for LVL 3 and 75% chance for no enhancement and 20% for one and 5% for two)
# ** If Boss = Obtain one out of four cards with 100% for LVL 3 and 50% for no enhancement, 25% for one, 20% for two and 5% for three 
# *** Chance for potion ((20% + (Chance for last potion * 0.7 )) + 100% if boss reward (yes this means that you can get two pots) (if you obtain a pot the chance goes back to 20%)
# **** Obtain a LVL 3 proccessor if boss, and LVL 1 processor if mini, (you can get LVL 2 from shops)

## Shop
# 4 random LVL 2 proccessors appear, each cost 140 - 180 gold
# 2 random [Physical] or [Standard] program, each cost 20 - 100 gold
# 2 random [Burst] or [Overlcoked] program, each cost 60 - 110 gold
# 2 random [Physical], [Burst], [Standard] or [Overlcoked] enhanced programs, each cost 30 - 150 gold
# 2 random potions, can purchase both for 40 - 60 gold
# 1 Mystery processor box, cannot see contents, contains 1 random LVL 2 processor and two random potions, costs 30 - 120 gold

## Processors
# If you already have a proccessor (Any LVL), you cannot see it again (You run out of processors instead you get a either a strength, health or charge booster (can have any number of them)
# ** Strength booster LVL <null> - (Attacks deal one additional damage)
# ** Health booster LVL <null> - (Gain +3 max health)
# ** Charge booster LVL <null> - (Gain +5 max battery charges)
# * Battle senses LVL 1 - (Events have a 20% chance to be replaced with a enemy comabt) -> LVL 2 (Enemy Combats have a 20% to be replaced with a Mini) -> LVL 3 (You can choose replace regular combats with a mini or a mini with a regular combat)  
# * Additional battery charges LVL 1 - (Gain 10 additional max battery charges) -> LVL 2 (Gain 20 additional max battery charges, lose 5 max health) -> LVL 3 (Gain 60 additional battery charges, lose 29 max health)
# * Merchants favour [Can only obtain from specific town village event] LVL 1 - (Recive a 25% discount on all purchases in the city) -> LVL 2 (Recive a 40% discount on all pruchases in the city) -> LVL 3 (Recive a 30% discount on all purchases)
# * Spiked plating LVL 1 (Gain 4 thorns at the start of each combat) -> LVL 2 (Gain 7 thorns at the start of each combat) -> LVL 3 (Gain 2 thorns at the start of each turn)
# * Water cooling LVL 1 (Negative temprature effects apply after an additional 30°) -> LVL 2 (Negative temprature effects apply after an additional 50°) -> LVL 3 (Negative temprature effects apply after an additional 100°)
# * Titanium pole LVL 1 (Whenever you recive damage take one less) -> LVL 2 (Whenever you recive damage take two less) -> LVL 3 (Whenever you recive damage only take 80% damage)
# * [Name TBD] LVL 1 (Whenever you lose health gain 5 battery charges) -> LVL 2 (Whenever you lose halth gain 10 battery charges) -> LVL 3 (Whenever you are below 10 battery charges gain 10 battery charges next turn)
# * Gold powered charges LVL 1 (Attacks deal 30% more damage, gain 20 less gold at the end of each combat) -> LVL 2 (Attacks deal 30% more damage, gain 10 less gold at the end of each combat) -> (Attacks deal 50% more damage, you can no longer gain gold)
# * [Name TBD] LVL 1 (Gain 20 additonal gold from events) -> LVL 2 (Gain 20 additional gold at the end of each combat) -> LVL 3 (Gain double gold at the end of each combat, purchases are 10% more expensive)
# * Curse of greed [Obtained from specific event] LVL 1 (Lose 10 gold each floor) -> LVL 2 (Lose 20 gold each floor) -> LVL 3 (Lose 40 gold each floor)
# * Bronze clock
#
# Data loss [Processor] Gain 1.5 additional max memory. At the start of each enemy encounter PERMANENTLY remove a program from your programs list
# Shield theif [Processor] Whenever an enemy gains shield steal 20% of it as battery charges. Lose 10 max health
# Wise financial decisions [Processor] If you do not purchase anything in a shop gain 80 gold. 
# Solar panels [Processor] Gain 1 additional max memory in encounters started during 06:00 to 20:00


## Program types
# * Malware - If not played at the end of each turn, recive a negative effect or debuff (Some powers give bonous for playing malware)
# * Virus - Applies a negative effect or debuff at the start of the next turn (Can be played for 0 memory and is unstable but when played appllies a debuff stronger than if left alone)
# ** Physical - Does not require memory use and (usally) doesn't last more than one turn (Literally a physical action i.e a punch)
# *** Burst - Kills itself at the start of next turn
# **** Standard - Uses at least 1 memory (Essintally StS power)
# ***** Overclocked - (Usally at least 1.5 memory) Kills itself after 2-3 turns, Are usally unstable, Usally also applies a small debuff

## Program ideas (Ensure that you add good Act 1 and Act 2 programs!)
# Evasive maneuvers [Physical] - Negative the next time you would take damage this turn / 1 Mem / Any
# Dodge and roll [Physical] - Deal 6 damage  Gain 1 Dodge / 0.5 Mem / All B
# Stomp [X] [Physical] Deal 8 [+4] damage / All B
# Scratch [X] [Physical] Deal 4 damage. Apply 1 [+1] injured / All D
# Crunch [X] [Physical] Deal 6 [+2] damage twice. Apply 1 stunned / All A
# [Burst]
# Infuser abuse [X] [Burst] Infuser effects are applied twice. [Can be infused X times]. Unstable / 1 Memory / All A
# Chaos! [2] [Burst] Gain confused and one additional turn before enemies attack. End your turn. Unstable / 1 [0] Memory / Any
# Time dilation [2] [Burst] Gain one additional turn before enemy attacks but do not gain energy back that turn. [~]Unstable[~] / 1 Memory / Any
# Heat rays [Burst] - Deal damage equal to core temprature divided by 10 / 1 Mem / All D
# Heat beam [Burst] - Deal 10 damage plus 1 for every 30° core temprature / 1 Mem / All A
# Inversment [Burst] - Gain 2 max memory ONLY next turn / 1 Mem / All C
# Loan [Burst] - Gain 2 max memory ONLY this turn  Lose 1 max memory ONLY next turn / 0 Mem / All C
# Malware launchers [Burst] - Deal 8 damage  Damage increases by 6 for every malware program in your hand / 0.5 Mem / Any
# [Standard]
# Memory rush [Standard] Malware programs cost 0 memory / 0.5 Mem / Any
# Energy conversion [Standard] Gain battery charges equal to core temprature divded by 15 / 0.5 Mem / All A
# Heatsinks [Standard] Lose 20° core temprature / 1 Mem / All C
# Malware protection [Standard] For every malware program in your hand gain a random buff / 1 Mem / All B
# [Overclocked]
# Reboot [X] [Overclocked] You cannot play programs. Gain 99 shield. Kills itself after 1 [X] turn[s] / 0 Memory / All D
# Data catalyst [Overclocked] All programs cost 0 memory  Gain confused  Kills itself after 3 turns / 3 Mem / Any
# Missile launcher [Overclocked] Deal 15 damage to all enemies  Kills itself after 3 turns / 1.5 Mem / Any
# Self destruct [Overlclocked] When this program is killed Take 99 damage then Deal damage equal to battery charges lost  Kills itself after 2 turns / 1.5 Mem / All D
# Antivirus [Overclocked] Virus programs cannot apply debuffs  Kills itslef after 2 turns / 2 Mem / ALL
# [Malware]
# Hello! [Malware] Add a Hello! to your program list for the rest of this encounter / 0 Memory / Any
# Headache [Malware] Gain 2 stunned / All D
# Blindness [Malware] Gain 2 Sightless / All A
# [Virus]
# Memory drain [Virus] Lose one max memory ONLY this turn / Lose two max memory ONLY this turn. Unstable / Any
# Spore infection [Virus] Lose one health / Heal 5. Add a spore infection to your program list this combat / Any
# Sticky [Virus] Apply 1 stunned / Apply 2 stunned. Unstable / Any


## Starter programs
# * Punch [X] [Physical] - Deal 8 [+3] damage / Any
# * Punch [X] [Physical] - Deal 8 [+3] damage / Any
# * Punch [X] [Physical] - Deal 8 [+3] damage / Any
# ** Recharge [X] [Burst] Recharge 5 [+4] battery charges / 0.5 Mem / Any
# ** Recharge [X] [Burst] Recharge 5 [+4] battery charges / 0.5 Mem / Any
# *** Heatsinks [X] [Standard] Lose 15° [+10] core temprature / 1 Mem / All C
# *** Deflector shields [2] [Overclocked] - Gain 5 [+2] battery charges and 5 [+1]°. Kills itself after 3 turns / 2 Mem / All B
# **** Suprsie! [Malware] - Apply a random debuff to everyone / Apply two random debuffs to everyone / 1 Mem / Any
# ***** Eye beams [X] [Burst] - Deal 12 damage to a random enemy then give 2 damaged and 1 [+1] injured / 1 Mem / All C

## Infuser ideas
# Data gain [Infuser] Add a random 0 memory program to your programs list for the rest of this encounter. Program gains unstable
# Vampire [Infuser] Heal health equal to half the damage dealt to this enemy
# Surprise? [Infuser] Add a random Malware program to your hand next turn. It costs zero memory. 
# Heat gain [Infuser] Gain 8 degrees
# Heat loss [Infuser] Lose 8 degrees


## Core temprature
# Resets to 80° at the start of each encounter
# Increases by 5° for every 1 Memory used at the end of each turn
# If is <160 you lose 3 health at the start of each turn
# If is <180 you lose 10 health at the start of each turn

## Turns
# 1A -> 1B -> 1C -> 1D -> 2A -> 2B -> etc
# If a program has Any, it has a 30% chance to appear at the top of your hand each turn
# If a program has All C it appears at the middle of your hand every C turn i.e 1C, 2C, etc
# If a program has ALL it appears at the bottom of you hand every turn
# Viruses always appear at the top of your hand every turn

## Health
# Enemy attacks and programs cannot cause you to run out of battery charges and lose health in one turn
# Enemy attacks and programs cannot causes you to lose more than 25 health in one turn
# Enemies lose shield after two turns

## Difficulties
# Standard [STD]
# Threatening [THR]
# Hazardous [HAZ]
# Lethal [LHL]
# Death [DTH]
# * Modifers:
# STD: 
# THR:
# Infected enemies appear 15% more often
# Enemies have 20% more health
# Lethal enemies attack for 10% more damage
# HAZ:
# Infected enemies appear 20% more often
# Enemies have 20% more health
# Lethal enemies attack for 20% more damage
# LHL:
# Infected enemies appear 25% more often
# Enemies have 20% more health
# Lethal enemies attack for 20% more damage
# Lethal enemies have 10% more health
# Gain 20% less gold from defeating enemies
# DTH:
# Infected enemies appear 30% more often
# Enemies have 20% more health
# Lethal enemies attack for 20% more damage
# Lethal enemies have 10% more health
# Gain 30% less gold from defeating enemies
# Start each run with Deadly Spores
# The Core Infector has new attacks
# Gain the intrest of a god

## Potions
# Potion of self revival [Potion] When drunk if you would die in the next 2 turns revive yourself with 30 battery charges
# Potion of rememberance [Potion] Play the next program twice.
# "A mystical potion said to enhance the drinkers rememberance."
# Potion of memory [Potion] Gain 1.5 additional mx memory this encounter
# "A mystical potion said to enhance the memeory of machines."
# Potion of strength [Potion] Gain 3 damange up
# "A mystical potion said to enhance the drinkers physical abilities."
# Potion of health [Potion] Gain 20 additional max health this encounter
# "A mystical potion said to enhance the drinkers healthiness."
# Potion of revival [Potion] The next time an ally dies revive them to max health and remove this potion
# "A mystical potion said to revive drinkers from the dead."
# Potion of life [Potion] Gain 10 additional max health and heal to max health
# "A mystical potion said to blessed by Snal themself."
# Potion of defence [Potion] Gain 3 defence up.
# "A mystical potion said to enhacne the drinkers defensive abilities."
# Potion of death [Potion] [STD] Gain 5 critical and 3 damage up
# "A mystical potion said to transform the drinker into death itself."
# Potion of death [Potion] [DTH] Die
# "Try drinking this now."
# Strange juices [Potion] Gain 2 random buffs
# "A mystical potion said to do something or rather."
# Vile juices [Potion] Apply 2 random debuffs to an enemy
# "A mystical potion said to infict pain on those who touch it."
# Molotov cocktail [Potion] Deal 25 damage to an enemy
# "A mystical potion said to be used to firebomb peoples houses."
# Phil & Co Trademark Brew [Potion] Gain 5 damage up and a random buff
# "A mysstical potion said to be a free gift for staying at any Phil & Co Inn."

## Achievements
# Hackerman (Enter a command in the debug console)
# Hey! I saw that! (Enable achievements in the debug console after they were disabled due to cheat commands)
# It's speedrunning time (Beat the game in under 30 minutes)
# Victory? (Die before the core infectors first attack)
# Victory! (Defeat the core infector)
# The snail who created it all (Confront Snal)
# Ascension (Make the world anew)
# These don't carry over you know (Beat the game with at least 100 spare gold and all potions slots filled)
# Collector (Draw a full hand of infused programs)
# Threatening (Beat the game on threateing difficulty) 
# Hazardous (Beat the game on hazardous difficulty) 
# Lethal (Beat the game on lethal difficulty) 
# Death (Beat the game on death difficulty) 
# Gotta go fast (Beat the game before day 5)
# Taking your time (Reach day 10)

## After core infector
# After defeating the core infector cutscence plays out where snal appears in a blinding flash and goes like
# "Hello [user_name]... I am Snal"
# "You might know me as that god that The cult of Snal worships"
# "You probally thought that I didn't exist like most people who come from the city do..."
# "You know I actually helped create that place'
# "It's why it's so developed compared to the surface of Alymeria"
# "You know I probally shouldn't have kept the two populations seperated for as long as I did..."
# "Uniting the two of them 30 years ago was one of the best descions that I made"
# "Anyways... the reason for my intervention"
# "The world... all of Alymeria"
# "Is saved all because of you"
# "And I'm not talking about this machine that your using"
# "I see you down there back in the facility where all this began"
# "Holled up in the freezer room... controlling this machine with a [IRL machine name]"
# "Tell me what you wish for and it will be yours"
# Then there are options like
# Riches (Start your next run with 150 gold)
# Immortality (Start your next run with + 10 max health
# Love (Start your next run with Jerry the Slime as an ally)
# [OPTION LOCKED] Requires all four Jerry parts (X/4) # X = number on you
# If you have 5 head of jerry [OPTION LOCKED] is replaced with:
# The death of all Jerrys (Present Corpse of Jerry)
#  If you choose The death of all Jerrys snal goes
# "Noooo!"
# "Jerry!"
# "WHY WOULD YOU DO THIS TO A JERRY"
# "Wait... this isn't even the body of a Jerry..."
# "WHY WOULD YOU KILL FOUR DIFFERNT JERRYS THEN STICH THEIR BODY PARTS TOGETHER!"
# "IS THIS SUPPOSED TO BE SOME KIND OF SICK JOKE!?"
# "THATS IT!"
# "YOU CHOSE THIS PATH"
# Then the dialogue box goes:
# Snal attacks for 56^108 damage! [Snal bossfight starts]

## Corpse of Jerry
# If you have Head, Arm, Leg and Heart of Jerry they combine into Corpse of Jerry
# Jerry part descriptions
# Head of Jerry - Why would you hurt Jerry...
# Arm of Jerry - At least Jerry tried...
# Leg of Jerry - Why are they even selling this...
# Heart of Jerry - Jerry just wanted to help...
# Corpse of Jerry - You monster...
# If a Jerry ally dies get Arm of Jerry
# If you defeat a Jerry get Head of Jerry
# If you don't have Leg of Jerry encounter rdm_a6_genreal on the last event floor of act 6
# If you didn't encounter rdm_a2_jerry encounter it on the last event floor of act 2
# If you didn't encounter rdm_a5_jerry encounter it on the last event floor of act 5
# In metro sequence there is a jerry on the train which says that it will help you in the fight, if jerry dies in the fight you get Heart of Jerry

## Snal bossfight
# Health - 800
# Starting buffs:
# Power of life (Whenever you play a program heals 3 health)
# Power of creation (Whenever you heal, heals double the amount)
# Power of destruction (At the end of every turn all enemies lose 3 health)
# Turns:
# Attacks for 56^108 damage
# Temprature shock (Increases core temprature by 40°)
# Slimy strike (Attacks for 30 damage twice. Adds a Sticky to your draw pile)
