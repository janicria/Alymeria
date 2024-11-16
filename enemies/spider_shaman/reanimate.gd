extends EnemyCard

const ENEMY = preload("res://scences/enemy/enemy.tscn")


func custom_play(_final_targets: Array[Node]) -> void:
	var enemy := ENEMY.instantiate()
	enemy.summon()
