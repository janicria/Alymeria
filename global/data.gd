extends Node

signal gold_changed

# Constants 
const STARTING_GOLD := 50
const BASE_CARD_REWARDS := 4
const BASE_COMMON_WEIGHT := 85.0
const BASE_UNCOMMON_WEIGHT := 10.0
const BASE_RARE_WEIGHT := 5.0
const StatusDescriptions := {
	# Without string replacements
	"attack": "[color=ff0000]Attack[/color] - Deal [color=ff0000]damage[/color] to an [color=CD57FF]enemy[/color]",
	"barrier": "[color=0044ff]Barrier[/color] - Prevents [color=ff0000]damage[/color] from [color=CD57FF]enemy[/color] [color=ff0000]attacks[/color] when applied to a [color=CD57FF]summon[/color]",
	"chaotic": "[color=CD57FF]Chaotic[/color] - Affects a random [color=CD57FF]target[/color]",
	"buff": "[color=1AD12C]Buff[/color] - Gain a random [color=1AD12C]buff[/color]",
	"debuff": "[color=AB3321]Deuff[/color] - Gain a random [color=1AD12C]debuff[/color]",
	"for": "[color=CD57FF]For[/color] - The below affects are applied to all cards in the pile",
	"or": "[color=CD57FF]OR[/color] - Only one of the two effects will be applied",
	"draw": "[color=3D7BFF]Draw[/color] - Add a [color=0044ff]card[/color] from your draw pile to your [color=ffff00]hand[/color]",
	"uncache": "[color=D9BB26]Uncache[/color] - Choose a [color=0044ff]card[/color] from your [color=D9BB26]cache[/color] pile to add to your [color=ffff00]hand[/color], cost 0 and gain [color=ff8121]burn[/color] if you have enough [color=D9BB26]cache tokens[/color]",
	"heal": "[color=ff0000]Heal[/color] - Recover [color=ff0000]health[/color]",
	"cancel": "[color=AB3321]Cancel[/color] - You cannot play [color=0044ff]cards[/color]. Decreases by 1 at the END of each turn",
	"card_damage_up": "[color=1AD12C]Damage up[/color] - [color=ff0000]Attacks[/color] deal additional [color=ff0000]damage[/color]",
	"on_draw": "[color=3D7BFF]On draw[/color] - The below affects are applied when the [color=0044ff]card[/color] is drawn",
	"duplicate": "[color=3D7BFF]Duplicate[/color] - Add a copy of this [color=0044ff]card[/color] to your draw pile for the rest of combat",
	
	# Card statuses
	"burn": "[color=ff8121]Burn[/color] - When this [color=0044ff]card[/color] is played or [color=AB3321]exhausted[/color], remove a copy of it from your deck, unless it is [color=D9BB26]uncached[/color]",
	"exhaust": "[color=AB3321]Exhaust[/color] - Can only be played once per combat and cannot be [color=D9BB26]cached[/color]",
	"heavy": "[color=A7A5A6]Heavy[/color] - Whenever the draw pile is shuffled, this [color=0044ff]card[/color] is moved to the bottom",
	"singular": "[color=9370db]Singular[/color] - Cost decreases one whenever you [color=D9BB26]uncache[/color] it. [color=D9BB26]Cache[/color] cost always equals 10",
	"unplayable": "Unplayable - This [color=0044ff]card[/color] cannot be played!",
	"temporary": "[color=2C9671]Temporary[/color] -  Right click this [color=0044ff]card[/color] to [color=AB3321]exhaust[/color] it",
	
	# Statuses
	"hidden": "[color=1AD12C]Hidden[/color] - [color=CD57FF]Enemies[/color] ignore this [color=CD57FF]summon[/color] when [color=ff0000]attacking[/color]. Decreases at the start of each turn",
	"webbed": "[color=AB3321]Webbed[/color] - [color=0044ff]Cards[/color] deal 30% less [color=ff0000]damage[/color]. Decreases at the start of each turn",
	"spinneret": "[color=1AD12C]Spinneret[/color] - Whenever you receive unblocked [color=AB3321]attack damage[/color] from this [color=CD57FF]enemy[/color], gain one [color=AB3321]Webbed[/color]",
	"nano_plague": "[color=AB3321]Nano plague[/color] - Take [color=ff0000]damage[/color] equal to 80% of stacks then apply [color=008000]nano plague[/color] equal to 20% of stacks to all [color=CD57FF]allies[/color] at the END of each turn",
	"injured": "[color=AB3321]Injured[/color] - Recive 30% more [color=ff0000]damage[/color] from [color=ff0000]attacks[/color]. Decreases by 1 at the END of each turn",
	
	# With string replacements
	"lucky_draw": "[color=9370db]Lucky draw[/color] - There is a [color=9370db]%d%%[/color] chance for this [color=0044ff]card[/color] to fail to play, chance decreases whenever you [color=3D7BFF]draw[/color] a [color=0044ff]card[/color]",
	"damage_up": "[color=1AD12C]Damage up[/color] - [color=ff0000]Attacks[/color] deal %s additional [color=ff0000]damage[/color]",
	"defence_up": "[color=1AD12C]Defence up[/color] - Gain %s more [color=0044ff]barrier[/color] from [color=0044ff]cards[/color]",
	"file_corruption": "[color=1AD12C]File corruption[/color] - Whenever you play a [color=0044ff]card[/color] apply %s [color=008000]nano plague[/color] to [color=CD57FF]everyone[/color]",
	"memory_down": "[color=AB3321]Memory down[/color] - Lose %s [color=ffff00]memory[/color] at the start of each turn. Amount is equal to looped [color=0044ff]card's[/color] cost",
	"suboptimal": "[color=1AD12C]Suboptimal[/color] - At the start of each turn lose %d [color=ff0000]health[/color] and gain %d [color=1AD12C]damage up[/color]"
}

# Nodes
var player_handler: PlayerHandeler
var bestiary: Bestiary
var core_handler: CoreHandler
var battle_ui: BattleUI
var shop: Shop

# Settings
var true_draw_amount := false
var true_deck_size := false
var card_pile_above_mana := true
var gameplay_tips := true
var speedy_cards := false

# Stats
var damage_taken := 0
var blocked_damage := 0
var damage_dealt := 0
var health_healed := 0
var cheats := false

# Bestiary variables
var spider_bestiary_entry := false
var bat_bestiary_entry := false

# Map
enum Biome {FOREST, TOWN, CAVES, CITY, TRAIN, STORM, FINAL}
var current_biome := Biome.FOREST : 
	set(value): current_biome = clampi(value, Biome.FOREST, (Biome.size()) -1)
var floor_is_infected := false
var biome_floors := {
	Biome.FOREST: 12,
	Biome.TOWN: 16,
	Biome.CAVES: 8,
	Biome.CITY: 16,
	Biome.TRAIN: 8,
	Biome.STORM: 8,
	Biome.FINAL: -1}

# Menu
var card_pile_open := false : 
	set(value):
		# Prevents settings from opening the same frame a card pile closes
		await get_tree().process_frame
		card_pile_open = value
var console_banned := false
var console_open := false
var bestiary_open := false


# Battle
var turn_number := 0
var character: CharacterStats
var multipliers := {
	"WEATHER": 1,
	"SHOP_COST": 1,
	"ENEMY_DAMAGE": 1,
	"ENEMY_HEALTH": 1,
	"INFECTION": 1,
	"ENEMY_MOVESET": 0,
	"ELITE_MOVESET": 0,
	"BOSS_MOVESET": 0,
	"WEATHER_MOVESET": 0,
	"UNCOMMON_CARD_RARITY": 0.0,
	"RARE_CARD_RARITY": 0.0}

# Rewards
var gold := STARTING_GOLD : 
	set(new_amount):
		gold = new_amount
		gold_changed.emit()
var card_rewards := BASE_CARD_REWARDS
var common_weight := BASE_COMMON_WEIGHT
var uncommon_weight := BASE_UNCOMMON_WEIGHT
var rare_weight := BASE_RARE_WEIGHT
var available_cores: Array[Core] = [
	preload("res://characters/global/cores/common/comically_large_anvil.tres"),
	preload("res://characters/global/cores/common/compass.tres"),
	preload("res://characters/global/cores/rare/blindfold.tres"),
	preload("res://characters/global/cores/rare/finale.tres"),
	preload("res://characters/global/cores/rare/maths_textbook.tres"),
	preload("res://characters/global/cores/uncommon/infected_horn.tres"),
	preload("res://characters/machine/cores/secure_boot.tres")
]
var removed_cores: Array[Core]


func _init() -> void:
	process_mode = PROCESS_MODE_ALWAYS
	Events.update_turn_number.connect(
		func(number:int)->void: turn_number = number)
	
	print("Successful launch")
	print("Version: %s (%s)" % [ProjectSettings.get_setting("application/config/version"), "Linux" if OS.has_feature("linux") else "Windows"])


func get_core_from_rarity(rarity: Core.Rarity) -> Core:
	available_cores.shuffle()
	for core in available_cores:
		if core.rarity == rarity:
			available_cores.erase(core)
			removed_cores.append(core)
			return core
	OS.alert("Ran out of cores in rarity %s" % rarity)
	return removed_cores.pick_random()


func get_core_from_weight() -> Core:
	var roll := randi_range(0, 100)
	if roll >= 80: return get_core_from_rarity(Core.Rarity.RARE)
	elif roll >= 60: return get_core_from_rarity(Core.Rarity.UNCOMMON)
	return get_core_from_rarity(Core.Rarity.COMMON)


@warning_ignore("untyped_declaration")
func hi(message = "") -> void:
	OS.alert("hiya" if str(message) == "" else str(message), "I think something broke :c")


func reset_stats() -> void:
	gold = STARTING_GOLD
	damage_dealt = 0
	damage_taken = 0
	blocked_damage = 0
	health_healed = 0
	cheats = false
	common_weight = BASE_COMMON_WEIGHT
	uncommon_weight = BASE_UNCOMMON_WEIGHT
	rare_weight = BASE_RARE_WEIGHT


# TODO: lmao
func save_to_file() -> bool:
	var result: bool
	result = true
	if result: print("Game saved! - %d" % (get_tree().get_frame()/60))
	else: OS.alert("Failed writing save file to path %s" % ProjectSettings.globalize_path("user://saves/save.exampleExtenstion"))
	
	return result
