extends BattleStats

var superboss: bool


func turn_effects() -> void:
	if superboss: return
	
	# Setting mana
	if Data.turn_number % 2 == 0: 
		live_enemies[1].mana = 0
		live_enemies[0].mana = live_enemies[1].stats.max_mana
	else:
		live_enemies[0].mana = 0
		live_enemies[1].mana = live_enemies[0].stats.max_mana
	
	for enemy in live_enemies: 
		enemy.sprite_2d.flip_h = true
		enemy.update_mana_counter()


func update_battle() -> void:
	if !live_enemies[0] || Data.turn_number != 0: return
	superboss = true
	Data.console_banned = true
	Events.toggle_console_visible.emit()
	live_enemies[0].stats.max_health = 1111
	live_enemies[1].stats.max_health = 666
	live_enemies[0].stats.health = 1111
	live_enemies[1].stats.health = 666
	live_enemies[0].stats.max_mana = 99
	live_enemies[0].stats.max_mana = 99
	live_enemies[0].mana = 99
	live_enemies[1].mana = 99
	live_enemies[0].ai = preload("res://enemies/evenodd/superboss/even_superboss_ai.tres")
	live_enemies[1].ai = preload("res://enemies/evenodd/superboss/odd_superboss_ai.tres")
