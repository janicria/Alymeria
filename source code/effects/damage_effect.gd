class_name DamageEffect
extends Effect

var amount := 0
var new_targets : Array[Node]


func execute(targets : Array[Node]) -> void:
	for target in targets:
		if target is Enemy or target is Player or target is Summon:
			target.take_damage(amount)
			SFXPlayer.play(sound)
