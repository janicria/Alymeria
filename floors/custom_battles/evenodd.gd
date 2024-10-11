extends BattleStats


func turn_effects() -> void:
	for enemy in live_enemies: enemy.sprite_2d.flip_h = true
	if GameManager.turn_number % 2 == 0: live_enemies[1].mana -= live_enemies[1].stats.max_mana
	else: live_enemies[0].mana -= live_enemies[0].stats.max_mana


func update_battle() -> void:
	if !live_enemies[0]: return
	live_enemies[0].stats.max_health = 1111
	live_enemies[1].stats.max_health = 666
	live_enemies[0].stats.health = 1111
	live_enemies[1].stats.health = 666
