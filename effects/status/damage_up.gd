class_name DamageUp
extends Status


func initalise_target(_target: Node) -> void:
	status_changed.connect(_on_status_changed)
	_on_status_changed()


func _on_status_changed() -> void:
	print("+%s dmg up" % stacks)
