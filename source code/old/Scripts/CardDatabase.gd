extends Resource


# CardInfo = [Charecter, Type, Rarity, Cost, Range, Desc, Name]
# Type = [0=Physical,  1-Burst,  2-Looped/Aura,  3-Overclocked/Summon,  4-Malware/Injury,  5-Virus/Status]
# Rarity = [0=Common,  1=Uncommon,  2=Rare,  3=Starter]
# Range = [0 = None required]
# Name = [null = use internal name]

enum {Flame, Barrier_Regeneration, Whack, Hex, Jynx}

const DATA = {
	Flame :
		["Witch", 1, 3, 1, 4, "Deal 3 damage", null],
	Barrier_Regeneration :
		["Witch", 1, 3, 1, 0, "Regenerate 3 barrier", 'Barrier Regeneration'],
	Whack :
		["Witch", 0, 3, 1, 2, "Deal 3 damage.
Draw 1 card", null],
	Hex :
		["Witch", 1, 3, 1, 3, "Apply a weak debuff", null],
	Jynx :
		["Witch", 3, 3, 2, 0, "Summon Jynx.
		Deals 4 damage to all enemies within a 3 tile radius and heals itself for 3.
		6 Health", null]
	}
