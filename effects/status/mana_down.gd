class_name ManaDown
extends Status


func apply_status(_target: Node) -> void:
	GameManager.character.mana -= stacks
