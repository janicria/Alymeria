extends EnemyCard

var actual_amount: int


func _init() -> void:
	actual_amount = randi_range(40, 130)


func custom_play(final_targets: Array[Node]) -> void:
	var damage_effect := DamageEffect.new()
	damage_effect.amount = actual_amount
	damage_effect.execute(final_targets)


func get_tooltip() -> String:
	return "This enemy is going to [color=ff0000]attack for %s[/color] to you when this card is played" % actual_amount
