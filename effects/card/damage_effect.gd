class_name DamageEffect extends Effect

var amount := 0
var status: Status

func execute(targets : Array[Node]) -> void:
	targets = targets.filter(func(target:Node)->bool: 
		return target is Enemy or target is Player or target is Summon)
	for target in targets:
		SFXPlayer.play(sound)
		if target is Player or target is Summon: 
			target.take_damage(amount, status)
		else: target.take_damage(amount)
