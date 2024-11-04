class_name EnemyCardUI extends Node2D

signal finished_playing

const WEBBED = preload("res://effects/status/webbed.tres")

@onready var cost: Label = %Cost
@onready var icon: TextureRect = %Icon
@onready var attack_icon: TextureRect = %AttackIcon
@onready var attack_desc: Label = %AttackDesc
@onready var arrow: Sprite2D = %Arrow

var card_stats: EnemyCard
var enemy_stats: Enemy
var final_targets: Array[Node]
var is_dead := false
var modified_damage: int
# Needed because of damage counter reading from modified_damage
var modified_barrier: int


func _ready() -> void:
	Events.enemy_died.connect(func(enemy: Enemy)->void: 
		if enemy == enemy_stats: kms())


func get_targets() -> Array[Node]:
	# Last enemy card to be played in hand searches for targets a second time after
	# being played, therefore we can return any node since the card is about to be freed,
	# however this Node needs to be self to prevent orphans nodes being created
	if !is_inside_tree(): return [self]
	
	var target := get_tree().get_first_node_in_group("player")
	if get_tree().get_node_count_in_group("summons"):
		target = get_tree().get_first_node_in_group("summons")
	
	var targets: Array[Node] = []
	
	# In case enemy has been freed (only a warning is thrown but ¯\_(ツ)_/¯ )
	var wr: WeakRef = weakref(enemy_stats); if !wr.get_ref(): return []
	
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


func kms() -> void:
	# Prevents method from spamming
	if !is_dead:
		cost.text = "X"
		icon.texture = preload("res://assets/ui/universal/cross.png")
		attack_desc.text = "X"
		is_dead = true
		if card_stats.type == card_stats.Type.ATTACK:
			Events.update_player_dmg_counter.emit((modified_damage if modified_damage else card_stats.amount) * card_stats.repeats * -1, false)


func update_stats_from_status(_type: Status.Type) -> void:
	update_stats(card_stats, enemy_stats, true)


func update_stats(card: EnemyCard, enemy: Enemy, from_status := false) -> void:
	if !is_node_ready(): await ready
	card_stats = card
	enemy_stats = enemy
	
	if !enemy_stats.status_handler.statuses_applied.is_connected(update_stats_from_status):
		enemy_stats.status_handler.statuses_applied.connect(update_stats_from_status)
	if !enemy_stats.status_handler.status_added.is_connected(update_stats_from_status):
		enemy_stats.status_handler.status_added.connect(update_stats_from_status.bind(Status.Type.EVENT))
	
	cost.text = str(card.cost)
	icon.texture = enemy.stats.art
	attack_icon.texture = card.icon_dict.get(card.type)
	
	# Updates the UI to include player and enemy modifiers in its calculations (horribly unreadable)
	var player := get_targets()[0] as Player
	if player && card.type == EnemyCard.Type.ATTACK:
		# Updating damage counter with the correct values requires removing the old values first
		if from_status: Events.update_player_dmg_counter.emit(modified_damage * card.repeats * -1, false)
		modified_damage = player.modifier_handler.get_modified_value(card_stats.amount, Modifier.Type.DMG_TAKEN)
		modified_damage = enemy_stats.modifier_handler.get_modified_value(modified_damage, Modifier.Type.DMG_DEALT)
		if from_status: Events.update_player_dmg_counter.emit(modified_damage * card.repeats, false)
		attack_desc.text = str(modified_damage)
	elif card.type == EnemyCard.Type.BARRIER or card.type == EnemyCard.Type.LARGE_BARRIER:
		modified_barrier = enemy_stats.modifier_handler.get_modified_value(card_stats.amount, Modifier.Type.BARRIER_GAINED)
		attack_desc.text = str(modified_barrier)
	else: attack_desc.text = str(card.amount)
	if card.repeats != 1: attack_desc.text += "x%s" % card_stats.repeats


func play() -> void:
	if is_queued_for_deletion(): 
		return
	
	var targets := get_targets()
	apply_effects(targets)


func apply_effects(targets: Array[Node]) -> void:
	if is_dead:
		await get_tree().process_frame
		finished_playing.emit()
		return
	if card_stats.custom_amount != "": 
		card_stats.custom_play(get_targets())
		return
	if enemy_stats == null: 
		return
	
	for i in card_stats.repeats:
		var effect: Effect
		match card_stats.type:
			EnemyCard.Type.ATTACK:
				effect = DamageEffect.new()
				effect.amount = modified_damage
				if enemy_stats.status_handler._has_status("spinneret"):
					effect.status = WEBBED.duplicate()
				effect.sound = preload("res://assets/sfx/enemy_attack.ogg")
			
			EnemyCard.Type.BARRIER: 
				effect = BarrierEffect.new()
				effect.amount = modified_barrier
			
			EnemyCard.Type.LARGE_BARRIER: 
				effect = BarrierEffect.new()
				effect.amount = modified_barrier
			
			EnemyCard.Type.DRAW: enemy_stats.draw_cards(card_stats.amount); return
			EnemyCard.Type.ENERGY: enemy_stats.mana += card_stats.amount; return
			
			EnemyCard.Type.BUFF: card_stats.custom_play(get_targets()); return
			EnemyCard.Type.DEBUFF: card_stats.custom_play(get_targets()); return
			EnemyCard.Type.SPAWN: card_stats.custom_play(get_targets()); return
			EnemyCard.Type.UNKNOWN: card_stats.custom_play(get_targets()); return 
		# If effect hasn't been changed by any modifiers
		if !effect.amount: effect.amount = card_stats.amount
		effect.sound = card_stats.SFX_dict.get(card_stats.type)
		effect.execute(targets)
		# Await is needed because signals are slow (I think??)
		await get_tree().create_timer(0.1).timeout
	finished_playing.emit()


func _on_control_mouse_entered() -> void:
	var wr: WeakRef = weakref(enemy_stats); if !wr.get_ref(): 
		Events.show_tooltip.emit(
		"This [color=CD57FF]enemy[/color] died, but it's [color=0044ff]card[/color] is still here for some reason? \n [s](bad programming)[/s]")
		return
	
	if card_stats.custom_amount != "":
		Events.show_tooltip.emit(card_stats.get_tooltip())
		return
	
	var tooltip_text := "This [color=CD57FF]enemy[/color] is going to "
	
	if card_stats.type == card_stats.Type.ATTACK && card_stats.repeats != 1:
		tooltip_text += "[color=ff0000]attack for %sx%s[/color]" % [card_stats.amount, card_stats.repeats]
	else: match card_stats.type:
		card_stats.Type.ATTACK: tooltip_text += "[color=ff0000]attack for %s[/color]" % card_stats.amount
		card_stats.Type.BARRIER: tooltip_text += "apply a small amount of [color=0044ff]barrier[/color]"
		card_stats.Type.LARGE_BARRIER: tooltip_text +=  "apply a large amount of [color=0044ff]barrier[/color]"
		card_stats.Type.DRAW: tooltip_text += "[color=3D7BFF]draw %s[/color] [color=0044ff]cards[/color]" % card_stats.amount
		card_stats.Type.ENERGY: tooltip_text += "[color=3D7BFF]replenish %s mana[/color]" % card_stats.amount
		card_stats.Type.BUFF: tooltip_text += "[color=1AD12C]apply a buff[/color]"
		card_stats.Type.DEBUFF: tooltip_text += "[color=AB3321]apply a debuff[/color]"
		card_stats.Type.SPAWN: tooltip_text += "spawn an [color=CD57FF]ally[/color]"
		card_stats.Type.UNKNOWN: tooltip_text += "do something unknown"
	
	if card_stats.type != card_stats.Type.ATTACK: match card_stats.targets:
		card_stats.Targets.SINGLE: tooltip_text += " [color=CD57FF]to you[/color]"
		card_stats.Targets.SELF: tooltip_text += " [color=CD57FF]to itself[/color]"
		card_stats.Targets.ENEMIES: tooltip_text += " [color=CD57FF]to you and your summons[/color]"
		card_stats.Targets.ALLIES: tooltip_text += " [color=CD57FF]to all enemies[/color]"
		card_stats.Targets.EVERYONE: tooltip_text += "[color=CD57FF]to everyone[/color]"
	
	tooltip_text += " when this [color=0044ff]card[/color] is played"
	Events.show_tooltip.emit(tooltip_text)
	
	enemy_stats.arrow.visible = !enemy_stats.arrow.visible


func _on_control_mouse_exited() -> void:
	Events.hide_tooltip.emit()
	
	# Safety for if enemy was freed
	var wr: WeakRef = weakref(enemy_stats)
	if !wr.get_ref(): return
	
	enemy_stats.arrow.visible = !enemy_stats.arrow.visible
