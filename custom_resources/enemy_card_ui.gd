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
	# Tree check is because of last card being played searches 
	# for targets a second time after being played
	if (!is_inside_tree() 
	|| card_stats.targets == EnemyCard.Targets.NONE 
	|| enemy_stats == null): 
		return []
	
	var target := get_tree().get_first_node_in_group("player")
	# Gets the frontmost summon
	for i in Data.summon_handler.get_child_count():
		# Yes this works with only one summon active
		if i == 0: i = 1
		if (!Data.summon_handler.get_child(-i).status_handler._has_status("hidden") 
		&& Data.summon_handler.get_child(-i).is_in_group("summons")): # If not it means the summon's dead
			target = Data.summon_handler.get_child(-i)
			break
	
	var targets: Array[Node] = []
	match card_stats.targets:
		EnemyCard.Targets.SINGLE: targets.append(target)
		EnemyCard.Targets.SELF: targets.append(enemy_stats)
		EnemyCard.Targets.ENEMIES: 
			targets.append_array(get_tree().get_nodes_in_group("player"))
			targets.append_array(get_tree().get_nodes_in_group("summons"))
		EnemyCard.Targets.ALLIES:
			targets.append_array(get_tree().get_nodes_in_group("enemies"))
		EnemyCard.Targets.EVERYONE:
			targets.append_array(get_tree().get_nodes_in_group("player"))
			targets.append_array(get_tree().get_nodes_in_group("summons"))
			targets.append_array(get_tree().get_nodes_in_group("enemies"))
		EnemyCard.Targets.RANDOM_ALLY:
			targets.append(get_tree()
			.get_nodes_in_group("enemies")
			.pick_random())
	
	for summon in targets:
		if summon == null: break
		if summon.status_handler._has_status("hidden"):
			targets.erase(summon)
	
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
	# Variables
	card_stats = card
	enemy_stats = enemy
	card_stats.cardui = self
	
	# Signals
	if !enemy_stats.status_handler.statuses_applied.is_connected(update_stats_from_status):
		enemy_stats.status_handler.statuses_applied.connect(update_stats_from_status)
	if !enemy_stats.status_handler.status_added.is_connected(update_stats_from_status):
		enemy_stats.status_handler.status_added.connect(update_stats_from_status.bind(Status.Type.EVENT))
	
	# Exports
	cost.text = str(card.cost)
	icon.texture = enemy.stats.art
	attack_icon.texture = card.icon_dict.get(card.type)
	if card.type == EnemyCard.Type.UNKNOWN:
		attack_icon.custom_minimum_size = Vector2(10, 10) # Compared to 15, 15
	
	if card_stats.type > 3: return
	
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
	
	apply_effects(get_targets())


func apply_effects(targets: Array[Node]) -> void:
	if is_dead || enemy_stats == null:
		await get_tree().process_frame
		finished_playing.emit()
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
			
			EnemyCard.Type.DRAW:
				for enemy: Enemy in get_targets():
					if enemy.mana > 0:
						enemy.draw_cards(card_stats.amount)
						await Data.enemy_handler.finished_drawing
				break
			EnemyCard.Type.ENERGY: 
				for enemy: Enemy in get_targets():
					enemy.mana += card_stats.amount
					enemy.update_mana_counter()
				break
			_:
				if is_dead: return
				card_stats.custom_play(get_targets())
				break
		
		# If effect hasn't been changed by any modifiers
		if !effect.amount: effect.amount = card_stats.amount
		effect.sound = card_stats.SFX_dict.get(card_stats.type)
		effect.execute(targets)
		# Await is needed because signals are slow (I think??)
		await get_tree().create_timer(0.1).timeout
	# Await is needed because godot is slooow
	await get_tree().process_frame
	finished_playing.emit()


func _on_control_mouse_entered() -> void:
	if enemy_stats == null: 
		Events.show_tooltip.emit(
		"This [color=CD57FF]enemy[/color] died, but it's [color=0044ff]card[/color] is still here for some reason? \n [s](bad coding)[/s]")
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
		card_stats.Targets.EVERYONE: tooltip_text += " [color=CD57FF]to everyone[/color]"
		card_stats.Targets.RANDOM_ALLY: tooltip_text += " [color=CD57FF]to a random enemy[/color]"
	
	tooltip_text += " when this [color=0044ff]card[/color] is played"
	Events.show_tooltip.emit(tooltip_text)
	
	# Can't do = !visible as sometimes these can be accidentally left on / off
	enemy_stats.arrow.visible = true


func _on_control_mouse_exited() -> void:
	Events.hide_tooltip.emit()
	
	if enemy_stats == null: 
		return
	
	# Can't do = !visible as sometimes these can be accidentally left on / off
	enemy_stats.arrow.visible = false
