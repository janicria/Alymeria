extends EnemyAction

@export var barrier := 6

func perform_action() -> void:
	if !enemy or !target:
		return
	
	var barrier_effect := BarrierEffect.new()
	barrier_effect.amount = barrier
	barrier_effect.sound = sound
	barrier_effect.execute([enemy])
	
	get_tree().create_timer(0.6, false).timeout.connect(
		func():
			Events.enemy_action_completed.emit(enemy)
	)
	

func tooltip_description() -> String:
	return "regain a small amount of [color=0044ff]barrier[/color]"
