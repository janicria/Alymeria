extends EnemyAction

@export var barrier := 15
@export var health_threshold := 8

var already_used := false


func is_performable() -> bool:
	if !enemy or already_used:
		return false
	
	var is_low := enemy.stats.health <= health_threshold
	already_used = is_low
	
	return is_low


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
	return "regain a large amount of [color=0044ff]barrier[/color]"
