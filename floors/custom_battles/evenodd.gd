extends BattleStats

var superboss: bool

func turn_effects() -> void:
	if superboss: return
	
	if GameManager.turn_number % 2 == 0: 
		live_enemies[1].mana = 0; live_enemies[0].mana = live_enemies[1].stats.max_mana
	else: live_enemies[0].mana = 0; live_enemies[1].mana = live_enemies[0].stats.max_mana
	for enemy in live_enemies: enemy.sprite_2d.flip_h = true; enemy.update_mana_counter()


func update_battle() -> void:
	#if !live_enemies[0]: return
	superboss = true
	print(2)
	live_enemies[0].stats.max_health = 1111
	live_enemies[1].stats.max_health = 666
	live_enemies[0].stats.health = 1111
	live_enemies[1].stats.health = 666
	live_enemies[0].stats.max_mana = 99
	live_enemies[0].stats.max_mana = 99
	live_enemies[0].mana = 99
	live_enemies[1].mana = 99
	live_enemies[0].ai = preload("res://enemies/evenodd/even_superboss_ai.tres")
	live_enemies[1].ai = preload("res://enemies/evenodd/odd_superboss_ai.tres")
