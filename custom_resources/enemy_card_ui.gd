class_name EnemyCardUI
extends Node2D

@onready var cost: Label = %Cost
@onready var icon: TextureRect = %Icon
@onready var attack_icon: TextureRect = %AttackIcon
@onready var attack_desc: Label = %AttackDesc

var card_stats: EnemyCard
var enemy_stats: Enemy
var final_targets: Array[Node]
var is_dead := false


func _ready() -> void:
	Events.enemy_died.connect(func(enemy:Enemy)->void: 
		if enemy == enemy_stats: kms())


func kms() -> void:
	# Prevents method from spamming
	if !is_dead:
		cost.text = "X"
		icon.texture = preload("res://assets/ui/enemies/cross.png")
		attack_desc.text = "X"
		is_dead = true
		if card_stats.type == card_stats.Type.ATTACK:
			Events.update_player_dmg_counter.emit(card_stats.amount * card_stats.repeats * -1, false)


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
	# Checks if enemy has been freed
	var wr: WeakRef = weakref(enemy_stats)
	if !wr.get_ref(): 
		Events.card_tooltip_requested.emit("[center]This enemy died, but it's card is still here for some reason? \n [s](bad programming)[/s][/center]")
		return
	
	var tooltip_text := "[center]This enemy is going to "

	if card_stats.type == card_stats.Type.ATTACK and card_stats.repeats != 1:
		tooltip_text += "[color=ff0000]attack for %sx%s[/color]" % [card_stats.amount, card_stats.repeats]
	else: match card_stats.type:
		card_stats.Type.ATTACK: tooltip_text += "[color=ff0000]attack for %s[/color]" % card_stats.amount
		card_stats.Type.BARRIER: tooltip_text += "apply a small amount of [color=0044ff]barrier[/color]"
		card_stats.Type.LARGE_BARRIER: tooltip_text +=  "apply a large amount of [color=0044ff]barrier[/color]"
		card_stats.Type.DRAW: tooltip_text += "draw %s cards" % card_stats.amount
		card_stats.Type.ENERGY: tooltip_text += "replenish %s mana" % card_stats.amount
		card_stats.Type.BUFF: tooltip_text += "apply a buff"
		card_stats.Type.DEBUFF: tooltip_text += "apply a debuff"
		card_stats.Type.SPAWN: tooltip_text += "spawn an ally"
		card_stats.Type.UNKNOWN: tooltip_text += "do something unknown"
	
	if card_stats.type != card_stats.Type.ATTACK: match card_stats.targets:
		card_stats.Targets.SINGLE: tooltip_text += " to you"
		card_stats.Targets.SELF: tooltip_text += " to itself"
		card_stats.Targets.ENEMIES: tooltip_text += "to you and your summons"
		card_stats.Targets.ALLIES: tooltip_text += "to all enemies"
		card_stats.Targets.EVERYONE: tooltip_text += "to everyone"
	
	tooltip_text += " when this card is played[/center]"
	Events.card_tooltip_requested.emit(tooltip_text)
	
	enemy_stats.arrow.visible = !enemy_stats.arrow.visible


func _on_control_mouse_exited() -> void:
	Events.tooltip_hide_requested.emit()
	
	# Safety for if enemy was freed
	var wr: WeakRef = weakref(enemy_stats)
	if !wr.get_ref(): return
	
	enemy_stats.arrow.visible = !enemy_stats.arrow.visible


func play() -> void:
	if self.is_queued_for_deletion():
		return
	
	var targets := get_targets()
	apply_effects(targets)


func get_targets() -> Array[Node]:
	var target := get_tree().get_first_node_in_group("player")
	if get_tree().get_node_count_in_group("summons"):
		target = get_tree().get_first_node_in_group("summons")
	
	var targets: Array[Node] = []
	
	# Incase enemy has been freed (only a warning is thrown but ¯\_(ツ)_/¯ )
	var wr: WeakRef = weakref(enemy_stats)
	if !wr.get_ref(): return []
	
	match card_stats.targets:
		card_stats.Targets.SINGLE: targets.append(target)
		card_stats.Targets.SELF: targets.append(enemy_stats)
		card_stats.Targets.ENEMIES: 
			targets.append_array(get_tree().get_nodes_in_group("player"))
			targets.append_array(get_tree().get_nodes_in_group("summons"))
		card_stats.Targets.ALLIES:
			targets.append_array(get_tree().get_nodes_in_group("enemies"))
		card_stats.Targets.EVERYONE:
			targets.append_array(get_tree().get_nodes_in_group("player"))
			targets.append_array(get_tree().get_nodes_in_group("summons"))
			targets.append_array(get_tree().get_nodes_in_group("enemies"))
	
	return targets


func apply_effects(targets: Array[Node]) -> void:
	if is_dead: return
	for i:int in card_stats.repeats:
		var effect: Effect # Indentation moment (cannot be declared in switch below then refrenced below)
		match card_stats.type:
			EnemyCard.Type.ATTACK:
				effect = DamageEffect.new()
				
			EnemyCard.Type.BARRIER :
				effect = BarrierEffect.new()
				# Game crashes if combined in an or statement with Type.Barrier ¯\_(ツ)_/¯
			EnemyCard.Type.LARGE_BARRIER:
				effect = BarrierEffect.new()
		effect.amount = card_stats.amount
		effect.sound = card_stats.SFX_dict.get(card_stats.type)
		effect.execute(targets)
		await get_tree().create_timer(0.15).timeout
