extends Status


func initalise_target(target: Node) -> void:
	status_changed.connect(_on_status_changed.bind(target))
	_on_status_changed(target)


func _on_status_changed(target: Node) -> void:
	# Getting mod
	var barrier_gained_modifier: Modifier = target.modifier_handler.get_modifier_of_type(
		Modifier.Type.BARRIER_GAINED)
	
	# Getting / creating mod value
	var defence_up_value: ModifierValue = barrier_gained_modifier.get_value("defence_up")
	if !defence_up_value:
		defence_up_value = ModifierValue.create_modifier(
			"defence_up", ModifierValue.Type.FLAT)
	
	# Updating mod
	defence_up_value.flat_value = stacks
	barrier_gained_modifier.add_new_value(defence_up_value)
