class_name Injured
extends Status


func initalise_target(target: Node) -> void:
	assert(target.get("modifier_handler"), "No mods on target %s" % target)
	var damage_taken_modifier: Modifier = target.modifier_handler.get_modifier_of_type(Modifier.Type.DMG_TAKEN)
	assert(damage_taken_modifier, "No dmg dealt mod on target %s" % target)
	
	# Getting / creating mod value
	var injured_value: ModifierValue = damage_taken_modifier.get_value("injured")
	if !injured_value:
		injured_value = ModifierValue.create_modifier("injured", ModifierValue.Type.PERCENT)
		injured_value.percent_value = 0.3
		damage_taken_modifier.add_new_value(injured_value)
	
	# Updating mod
	if !status_changed.is_connected(_on_status_changed):
		status_changed.connect(_on_status_changed.bind(damage_taken_modifier))


func _on_status_changed(damage_taken_modifier: Modifier) -> void:
	if duration <= 0 && damage_taken_modifier: 
		damage_taken_modifier.remove_value("injured")
