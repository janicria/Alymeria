class_name EnemyHand
extends HBoxContainer

const ENEMY_CARD_SCENE = preload("res://custom_resources/enemy_card.tscn")

@export var time_before_next_card := 0

var organiser_target_pos := position - Vector2(30, -5)

func cardToGui(card: EnemyCard, enemy: Enemy) -> void:
	var card_ui := ENEMY_CARD_SCENE.instantiate()
	card_ui.position = enemy.position - Vector2(100, 40)
	card_ui.update_stats(card, enemy)
	add_child(card_ui)
	var target_pos := position - Vector2(30, -5)
	for i in get_child_count():
		target_pos.x += 38
		if !card.health: await get_tree().create_timer(0.3).timeout
	card_ui.visible = true
	var tween := create_tween().set_trans(Tween.TRANS_BACK)
	tween.tween_property(card_ui, "global_position", target_pos, 0.6)


func organise_cards(draw_next_card := true) -> void:
	await get_tree().create_timer(0.1).timeout # For cards which are queued_for_deletion()
	organiser_target_pos = position - Vector2(30, -5) 
	time_before_next_card = 0
	for card: EnemyCardUI in get_children():
		organiser_target_pos.x += 38
		var tween := create_tween().set_trans(Tween.TRANS_BACK)
		tween.tween_property(card, "global_position", organiser_target_pos, 0.5)
		await get_tree().create_timer(0.1).timeout
		time_before_next_card += 0.1
	if draw_next_card: Events.enemy_card_played.emit()
