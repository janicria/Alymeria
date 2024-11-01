class_name DamageEffect extends Effect

var amount := 0
var status: Status

func execute(targets : Array[Node]) -> void:
	targets.filter(func(target:Node)->bool: 
		return target is Enemy or target is Player)
	for target in targets:
		SFXPlayer.play(sound)
		if target is Player: 
			target.take_damage(amount, status)
		else: target.take_damage(amount)
