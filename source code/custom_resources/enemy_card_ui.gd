class_name EnemyCardUI
extends Node2D

@onready var cost: Label = %Cost
@onready var icon: TextureRect = %Icon
@onready var attack_icon: TextureRect = %AttackIcon
@onready var attack_desc: Label = %AttackDesc

var card_stats: EnemyCard
var enemy_stats: Enemy
var final_targets: Array[Node]

func update_stats(card: EnemyCard, enemy: Enemy) -> void:
	if !is_node_ready():
		await ready
	
	card_stats = card
	enemy_stats = enemy
	
	cost.text = str(card.cost)
	icon.texture = enemy.stats.art
	attack_icon.texture = card.icon_dict.get(card.type)
	attack_desc.text = str(card.amount)
	if card.repeats != 1:
		attack_desc.text += "x" + str(card.repeats)
	




func _on_control_mouse_entered() -> void:
	var tooltip_text:String = "[center]This enemy is going to " + card_stats.tooltip_text_dict.get(card_stats.type)
	
	if card_stats.type == card_stats.Type.ATTACK and card_stats.repeats != 1:
		tooltip_text += str(card_stats.amount) + "x" + str(card_stats.repeats) + "[/color]"
	elif card_stats.type == card_stats.Type.ATTACK: tooltip_text += str(card_stats.amount) + "[/color]"
	elif card_stats.type == card_stats.Type.DRAW: tooltip_text += str(card_stats.amount) + " cards"
	elif card_stats.type == card_stats.Type.ENERGY: tooltip_text += str(card_stats.amount) + " energy"
	elif card_stats.type == card_stats.Type.BUFF: tooltip_text += str(card_stats.amount) + " to itself"
	elif card_stats.type == card_stats.Type.DEBUFF: tooltip_text += str(card_stats.amount)
	
	tooltip_text +=  " when this card is played[/center]"
	Events.card_tooltip_requested.emit(tooltip_text)
	
	enemy_stats.update_box()


func _on_control_mouse_exited() -> void:
	Events.tooltip_hide_requested.emit()
	enemy_stats.update_box()


func play() -> void:
	if self.is_queued_for_deletion():
		return
	
	var targets := get_targets()
	print(targets)
	apply_effects(targets)


func get_targets() -> Array[Node]:
	var target := get_tree().get_first_node_in_group("player")
	if get_tree().get_node_count_in_group("summons"):
		target = get_tree().get_first_node_in_group("summons")
	
	var targets: Array[Node] = []
	
	if card_stats.targets == EnemyCard.Targets.SINGLE: targets.append(target)
	elif card_stats.targets == EnemyCard.Targets.SELF: targets.append(enemy_stats)
	elif card_stats.targets == EnemyCard.Targets.ENEMIES: 
		targets.append_array(get_tree().get_nodes_in_group("player"))
		targets.append_array(get_tree().get_nodes_in_group("summons"))
	elif card_stats.targets == EnemyCard.Targets.ALLIES:
		targets.append_array(get_tree().get_nodes_in_group("enemies"))
	elif card_stats.targets == EnemyCard.Targets.EVERYONE:
		targets.append_array(get_tree().get_nodes_in_group("player"))
		targets.append_array(get_tree().get_nodes_in_group("summons"))
		targets.append_array(get_tree().get_nodes_in_group("enemies"))
	
	return targets


func apply_effects(targets: Array[Node]) -> void:
	var effect
	if card_stats.type == EnemyCard.Type.ATTACK: effect = DamageEffect.new()
	else: effect = BarrierEffect.new() # FIXME: Debug code
	effect.amount = card_stats.amount
	effect.sound = card_stats.SFX_dict.get(card_stats.type)
	effect.execute(targets)
	#print("played %s card for %s" % [card_stats.type, targets])
