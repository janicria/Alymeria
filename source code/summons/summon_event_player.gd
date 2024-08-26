extends Node


func _ready() -> void:
	Events.summon_do_attack.connect(do_attack)


func do_attack(id : String, amount : int, is_ability : bool) -> void:
	for i in amount:
		if id == "AttackSentry":
			var rand_attack = RandomAttack.new()
			rand_attack.start(true, false, 6, 1, id)
		elif id == "AttackSentry" and is_ability:
			print("applying 1 damage up to all allies ", id)
