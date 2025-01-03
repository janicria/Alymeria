extends Status


func initalise_target(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	# Getting mod
	var damage_dealt_modifier: Modifier = target.modifier_handler.get_modifier_of_type(Modifier.Type.DMG_DEALT)
	
	# Getting / creating mod value
	var damage_up_value: ModifierValue = damage_dealt_modifier.get_value("damage_up")
	if !damage_up_value:
		damage_up_value = ModifierValue.create_modifier(
			"damage_up", ModifierValue.Type.FLAT)
	
	# Updating mod
	damage_up_value.flat_value = stacks
	damage_dealt_modifier.add_new_value(damage_up_value)
