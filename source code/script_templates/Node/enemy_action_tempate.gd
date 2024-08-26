# meta-name: EnemyAction
# meta-description: An action which can be performed by an enemy during its turn
extends EnemyAction


func perform_action() -> void:
	if !enemy or !target:
		return
	
	var tween := create_tween().set_trans(Tween.TRANS_QUINT)
	var start := enemy.global_position
	var end := target.global_position + Vector2.RIGHT * 20
	
	SFXPlayer.play(sound)
	
	# Add action here
	
	Events.enemy_action_completed.emit(enemy)
