class_name DamageEffect
extends Effect

var amount := 0


func execute(targets : Array[Node]) -> void:
	targets.filter(func(target:Node)->bool: 
		return target is Enemy or target is Player or target is Summon)
	for target in targets:
		SFXPlayer.play(sound)
		if target: target.take_damage(amount)
