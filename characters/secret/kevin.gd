extends Card


func apply_effects(targets: Array[Node], _modifiers: ModifierHandler) -> void:
	targets[0].get_tree().change_scene_to_packed(preload("res://scences/credits/victory.tscn"))
